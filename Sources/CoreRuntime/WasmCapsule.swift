import Foundation
import WasmKit

public struct WasmCapsule {

	public enum CapsuleError: Error {
		case functionNotFound(String)
	}

	private let engine: Engine
	private let store: Store

	public init(engine: Engine = Engine()) {
		self.engine = engine
		self.store = Store(engine: engine)
	}

	@discardableResult
	public func execute(
		bytes: [UInt8],
		entryFunction: String = "_start",
		arguments: [Value] = [],
		imports: Imports = Imports()
	) throws -> [Value] {
		let module = try parseWasm(bytes: bytes, features: engine.configuration.features)
		let instance = try module.instantiate(store: store, imports: imports)

		guard let function = instance.exports[function: entryFunction] else {
			throw CapsuleError.functionNotFound(entryFunction)
		}
		return try function.invoke(arguments)
	}

	@discardableResult
	public func execute(
		data: Data,
		entryFunction: String = "_start",
		arguments: [Value] = [],
		imports: Imports = Imports()
	) throws -> [Value] {
		try execute(
			bytes: [UInt8](data),
			entryFunction: entryFunction,
			arguments: arguments,
			imports: imports
		)
	}

}
