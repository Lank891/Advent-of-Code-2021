import java.lang.Long.parseLong
import scala.annotation.switch
import scala.collection.mutable.ArrayBuffer
import scala.io.Source

object Const {
  val inputFile = "./input.txt"
}

object PacketUtility {
  val valuePacketId = 4

  def GetPacketVersionAndType(packet: String): (Int, Int) = {
    val version = Integer.parseUnsignedInt(packet.substring(0, 3), 2)
    val id = Integer.parseUnsignedInt(packet.substring(3, 6), 2)
    (version, id)
  }

  def GetNextPacket(packet: String): Packet = {
    val (version, id) = GetPacketVersionAndType(packet)
    if(id == valuePacketId) { // Literal Value Packet
      var i = 6
      var bits = ""
      while(true) {
        for(j <- 1 until 5) {
          bits += packet(i+j)
        }
        if(packet(i) == '0') {
          return new ValuePacket(version, id, i+5, parseLong(bits, 2))
        }
        i += 5
      }
      null
    }
    else { // Operator Packet
      val subPackets = new ArrayBuffer[Packet]()
      var totalLength = 7

      if(packet(6) == '0') { // We know length of subPackets
        totalLength += 15
        var nextSubPacketIndex = 22
        val totalSubPacketsLength = Integer.parseUnsignedInt(packet.substring(7, nextSubPacketIndex),2)
        var foundSubPacketsLength = 0
        while(foundSubPacketsLength < totalSubPacketsLength) {
          val nextSubPacket = GetNextPacket(packet.substring(nextSubPacketIndex))
          nextSubPacketIndex += nextSubPacket.length
          foundSubPacketsLength += nextSubPacket.length
          subPackets.append(nextSubPacket)
        }
      }
      else { // We know amount of subPackets
        totalLength += 11
        var nextSubPacketIndex = 18
        val numberOfSubPackets = Integer.parseUnsignedInt(packet.substring(7, nextSubPacketIndex),2)
        for(_ <- 0 until numberOfSubPackets) {
          val nextSubPacket = GetNextPacket(packet.substring(nextSubPacketIndex))
          nextSubPacketIndex += nextSubPacket.length
          subPackets.append(nextSubPacket)
        }
      }

      for(p <- subPackets) {
        totalLength += p.length
      }

      new OperatorPacket(version, id, totalLength, subPackets.toArray)
    }
  }
}

abstract class Packet(val version: Int, val id: Int, val length: Int) {
  def getValue: Long
  def getTotalVersion: Int = {
    version
  }

  override def toString: String = {
    s"Packet (Ver: $version, Id: $id, Length: $length)"
  }
}

class ValuePacket(override val version: Int, override val id: Int, override val length: Int, var value: Long) extends Packet(version, id, length) {
  override def getValue: Long = {
    value
  }

  override def toString: String = {
    s"${super.toString}: Value = $value"
  }
}

class OperatorPacket(override val version: Int, override val id: Int, override val length: Int, val subPackets: Array[Packet]) extends Packet(version, id, length) {
  def getValue: Long = {
    (id: @switch) match {
      case 0 => subPackets.foldLeft(0L)((v, packet) => v + packet.getValue)
      case 1 => subPackets.foldLeft(1L)((v, packet) => v * packet.getValue)
      case 2 => subPackets.map(packet => packet.getValue).min
      case 3 => subPackets.map(packet => packet.getValue).max
      case 5 => if (subPackets(0).getValue > subPackets(1).getValue) 1 else 0
      case 6 => if (subPackets(0).getValue < subPackets(1).getValue) 1 else 0
      case 7 => if (subPackets(0).getValue == subPackets(1).getValue) 1 else 0
    }
  }

  override def getTotalVersion: Int = {
    subPackets.foldLeft(version)((last, packet) => last + packet.getTotalVersion)
  }

  override def toString: String = {
    s"${super.toString}: SubPackets: ${subPackets.length}"
  }
}

object Main extends App {
  val fileSource = Source.fromFile(Const.inputFile)
  var bits = fileSource.getLines.toList.head.map(c => String.format("%1$4s" ,Integer.parseUnsignedInt(c.toString, 16).toBinaryString).replace(' ', '0')).foldLeft("")((prev, n) => prev.concat(n))
  fileSource.close

  val packet = PacketUtility.GetNextPacket(bits)

  println(s"Part 1: ${packet.getTotalVersion}")
  println(s"Part 2: ${packet.getValue}")
}
