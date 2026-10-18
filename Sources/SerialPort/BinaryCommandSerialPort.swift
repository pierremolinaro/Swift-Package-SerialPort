//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 10/10/2026.
//--------------------------------------------------------------------------------------------------

import Foundation
import Observation
import BinarySerialFormat
import Synchronization

//--------------------------------------------------------------------------------------------------

@MainActor @Observable
open class BinaryCommandSerialPort <SEND_CODE : BinarySendCodeProtocol,
                                    RECEIVE_CODE : BinaryReceiveCodeProtocol> : SerialPort {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mBinarySerialFormatManager = Mutex <BinarySerialFormat <SEND_CODE, RECEIVE_CODE>> (BinarySerialFormat ())

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open nonisolated override func removeAllReceivedDatas () {
    self.mBinarySerialFormatManager.withLock { $0.removeAllReceivedDatas () }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Send
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public nonisolated func send (command inCommand : SEND_CODE) {
    self.sendData (self.mBinarySerialFormatManager.withLock { $0.data (forCommand: inCommand) })
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public nonisolated func send (encodedU64 inValue : UInt64) {
    self.sendData (self.mBinarySerialFormatManager.withLock { $0.data (forEncodedU64: inValue) })
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public nonisolated func send (encodedString inValue : String) {
    self.sendData (self.mBinarySerialFormatManager.withLock { $0.data (forEncodedString: inValue) })
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Receive
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ObservationIgnored private var mReceiveCallBack : Optional < @MainActor (_ inCommand : Command <RECEIVE_CODE>) -> Void > = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setReceiveCallBack (_ inReceiveCallBack : Optional < @MainActor (_ inCommand : Command <RECEIVE_CODE>) -> Void >) {
    self.mReceiveCallBack = inReceiveCallBack
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated public override func handleReceivedData (_ inData : Data) {
//    var s = ""
//    for byte in inData {
//      s += " \(String (byte, radix: 16, uppercase: true))"
//    }
//    Swift.print ("Received[\(inData.count)]:\(s)")
    var commands = [Command <RECEIVE_CODE>] ()
    self.reportReceivingState (inData.count)
    self.mBinarySerialFormatManager.withLock { $0.handleReceivedData (inData, &commands) }
    for command in commands {
      Task { @MainActor in self.mReceiveCallBack? (command) }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
