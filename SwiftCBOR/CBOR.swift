public enum CBOR : Equatable, Hashable {
	case PositiveInt(UInt)
	case NegativeInt(UInt)
	case ByteString([UInt8])
	case UTF8String(String)
	case Array([CBOR])
	case Map([CBOR : CBOR])
	case Simple(UInt8)
	case Boolean(Bool)
	case Null
	case Undefined
	case Half(Float32)
	case Float(Float32)
	case Double(Float64)
	case Break
	
	public var hashValue : Int {
		switch self {
		case let .PositiveInt(l): return l.hashValue
		case let .NegativeInt(l): return l.hashValue
		case let .ByteString(l):  return Util.djb2Hash(l.map { Int($0) })
		case let .UTF8String(l):  return l.hashValue
		case let .Array(l):	      return Util.djb2Hash(l.map { $0.hashValue })
		case let .Map(l):         return Util.djb2Hash(l.map { $0.hashValue &+ $1.hashValue })
		case let .Simple(l):      return l.hashValue
		case let .Boolean(l):     return l.hashValue
		case Null:                return -1
		case Undefined:           return -2
		case let .Half(l):        return l.hashValue
		case let .Float(l):       return l.hashValue
		case let .Double(l):      return l.hashValue
		case Break:               return Int.min
		}
	}
}

public func ==(lhs: CBOR, rhs: CBOR) -> Bool {
	switch (lhs, rhs) {
	case (let .PositiveInt(l), let .PositiveInt(r)): return l == r
	case (let .NegativeInt(l), let .NegativeInt(r)): return l == r
	case (let .ByteString(l),  let .ByteString(r)):  return l == r
	case (let .UTF8String(l),  let .UTF8String(r)):  return l == r
	case (let .Array(l),       let .Array(r)):       return l == r
	case (let .Map(l),         let .Map(r)):         return l == r
	case (let .Simple(l),      let .Simple(r)):      return l == r
	case (let .Boolean(l),     let .Boolean(r)):     return l == r
	case (.Null,               .Null):               return true
	case (.Undefined,          .Undefined):          return true
	case (let .Half(l),        let .Half(r)):        return l == r
	case (let .Float(l),       let .Float(r)):       return l == r
	case (let .Double(l),      let .Double(r)):      return l == r
	case (.Break,              .Break):              return true
	default:                                         return false
	}
}