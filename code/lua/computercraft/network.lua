-- http://lua-users.org/wiki/ReadWriteFormat

function write_format(little_endian, format, ...)
  local res = ''
  local values = {...}
  for i=1,#format do
    local size = tonumber(format:sub(i,i))
    local value = values[i]
    local str = ""
    for j=1,size do
      str = str .. string.char(value % 256)
      value = math.floor(value / 256)
    end
    if not little_endian then
      str = string.reverse(str)
    end
    res = res .. str
  end
  return res
end

function read_format(little_endian, format, str)
  local idx = 0
  local res = {}
  for i=1,#format do
    local size = tonumber(format:sub(i,i))
    local val = str:sub(idx+1,idx+size)
    local value = 0
    idx = idx + size
    if little_endian then
      val = string.reverse(val)
    end
    for j=1,size do
      value = value * 256 + val:byte(j)
    end
    res[i] = value
  end
  return unpack(res)
end

-- == System Constants ==

local EVENT_ICMP = "net_icmp"
local EVENT_UDP = "net_udp"
local EVENT_ARP = "net_arp"
local EVENT_IP = "net_ip"
local MAC_PROTO_IP = 0x800
local MAC_PROTO_ARP = 0x806
local ARP_HW_TYPE = 1
local ARP_OP_REQUEST = 1
local ARP_OP_REPLY = 2
local IP_VERSION = 4
local IP_HEADERLENGTH = 20
local IP_TTL = 64
local IP_PROTO_ICMP = 1
local IP_PROTO_UDP = 17
local UDP_HEADERLENGTH = 8

-- == System Vars ==

local nGatewayID = 1
local nLocalIP = ipToDec("192.168.0.1")

-- == Utils ==

function bit.bextract(nNumber, nOffset, nLength) -- OK
    nNumber = bit.brshift(nNumber, nOffset)
    return bit.band(nNumber, 2 ^ nLength - 1)
end

function getGatewayID()
    return nGatewayID
end

function getLocalIP()
    return nLocalIP
end

function ipToDec(sIp) -- OK
    local aIp = { string.match(sIp, "^(%d+).(%d+).(%d+).(%d+)$") }
    aIp[1] = bit.blshift(aIp[1], 24)
    aIp[2] = bit.blshift(aIp[2], 16)
    aIp[3] = bit.blshift(aIp[3], 8)

    return aIp[1] + aIp[2] + aIp[3] + aIp[4]
end

function decToIp(nIp) -- OK
    local aIp = {}
    aIp[1] = bit.bextract(nIp, 24, 8)
    aIp[2] = bit.bextract(nIp, 16, 8)
    aIp[3] = bit.bextract(nIp, 8, 8)
    aIp[4] = bit.bextract(nIp, 0, 8)

    return aIp[1] .. "." .. aIp[2] .. "." .. aIp[3] .. "." .. aIp[4]
end

-- == Primitives ==

function sendICMP(nDestAddr, nType, nCode, sData) -- OK
    local sType = write_format(false, "1", nType)
    local sCode = write_format(false, "1", nCode)
    local sChecksum = write_format(false, "2", 0)

    sendIP(IP_PROTO_ICMP, getLocalIP(), nDestAddr, sType .. sCode .. sChecksum .. sData)

    return true
end

function sendUDP(nDestAddr, nSrcPort, nDestPort, sData) -- OK
    local sSrcPort = write_format(false, "2", nSrcPort)
    local sDestPort = write_format(false, "2", nDestPort)
    local sLength = write_format(false, "2", string.len(sData) + UDP_HEADERLENGTH)
    local sChecksum = write_format(false, "2", 0)

    sendIP(IP_PROTO_UDP, getLocalIP(), nDestAddr, sSrcPort .. sDestPort .. sLength .. sChecksum .. sData)

    return true
end

function sendIP(nProtocol, nSrcAddr, nDestAddr, sData) -- OK
    local sVersionIhl = write_format(false, "1", bit.blshift(IP_VERSION, 4) + IP_HEADERLENGTH / 4)
    local sTos = write_format(false, "1", 0)
    local sLength = write_format(false, "2", IP_HEADERLENGTH + string.len(sData))
    local sIdent = write_format(false, "2", 0)
    local sFrag = write_format(false, "2", 0)
    local sTtl = write_format(false, "1", IP_TTL)
    local sProt = write_format(false, "1", nProtocol)
    local sChecksum = write_format(false, "2", 0)
    local sSrcInetAddr = write_format(false, "4", nSrcAddr)
    local sDestInetAddr = write_format(false, "4", nDestAddr)

    send(getGatewayId(), MAC_PROTO_IP, sVersionIhl .. sTos .. sLength .. sIdent .. sFrag .. sTtl .. sProt .. sChecksum .. sSrcInetAddr .. sDestInetAddr .. sData)

    return true
end

function sendARP(nOperation, nDestId, nDestAddr) -- OK
    local sHwType = write_format(false, "2", ARP_HW_TYPE)
    local sProtType = write_format(false, "2", MAC_PROTO_IP)
    local sHwAddrLen = write_format(false, "1", 2)
    local sProtAddrLen = write_format(false, "1", 4)
    local sOperation = write_format(false, "2", nOperation)
    local sSrcHwAddr = write_format(false, "2", os.getComputerID())
    local sSrcProtAddr = write_format(false, "4", getLocalIP())
    local sDestHwAddr = write_format(false, "2", nDestId)
    local sDestProtAddr = write_format(false, "4", nDestAddr)

    send(nDestId, MAC_PROTO_ARP,  sHwType .. sProtType .. sHwAddrLen .. sProtAddrLen .. sOperation .. sSrcHwAddr .. sSrcProtAddr .. sDestHwAddr .. sDestProtAddr)

    return true
end

function send(nDestId, nType, sData) -- OK
    local sType = write_format(false, "2", nType)
    rednet.send(nDestId, sType .. sData)

    return true
end

function receiveICMP() -- OK
    receiveIP()
    local _, _, sData = os.pullEvent(EVENT_ICMP)

    local sType = read_format(false, "1", string.sub(sData, 1, 1))
    local sCode = read_format(false, "1", string.sub(sData, 2, 2))
    local sChecksum = read_format(false, "2", string.sub(sData, 3, 4))
    local sData = string.sub(sData, 5)

    return { sType, sCode, sChecksum }, sData
end

function receiveUDP() -- OK
    receiveIP()
    local _, _, sData = os.pullEvent(EVENT_UDP)

    local nSrcPort = write_format(false, "2", string.sub(sData, 1, 4))
    local nDestPort = write_format(false, "2", string.sub(sData, 5, 8))
    local nLength = write_format(false, "2", string.sub(sData, 9, 12))
    local nChecksum = write_format(false, "2", string.sub(sData, 13, 16))
    local sData = string.sub(sData, 17)

    return { sSrcPort, sDestPort, sLength, sChecksum }, sData
end

function receiveIP() -- OK
    receiveMAC()
    local _, _, sData = os.pullEvent(EVENT_IP)
    local sEvent

    local nVersionIhl = read_format(false, "1", string.sub(sData, 1, 1))
    local nTos = read_format(false, "1", string.sub(sData, 2, 2))
    local nLength = read_format(false, "2", string.sub(sData, 3, 4))
    local nIdent = read_format(false, "2", string.sub(sData, 5, 6))
    local nFrag = read_format(false, "2", string.sub(sData, 7, 8))
    local nTtl = read_format(false, "1", string.sub(sData, 9, 9))
    local nProt = read_format(false, "1", string.sub(sData, 10, 10))
    local nChecksum = read_format(false, "2", string.sub(sData, 11, 12))
    local nSrcInetAddr = read_format(false, "4", string.sub(sData, 13, 16))
    local nDestInetAddr = read_format(false, "4", string.sub(sData, 17, 20))
    local sData = string.sub(sData, 21)

    if nProt == IP_PROTO_ICMP then
        sEvent = EVENT_ICMP
    elseif nProt == IP_PROTO_UDP then
        sEvent = EVENT_UDP
    end

    os.queueEvent(sEvent, { nVersionIhl, nTos, nLength, nIdent, nFrag, nTtl, nProt, nChecksum, nSrcInetAddr, nDestInetAddr }, sData)

    return true
end

function receiveARP() -- OK
    receiveMAC()
    local _, _, sData = os.pullEvent(EVENT_ARP)

    local nHwType = read_format(false, "2", string.sub(sData, 1, 2))
    local nProtType = read_format(false, "2", string.sub(sData, 3, 4))
    local nHwAddrLen = read_format(false, "1", string.sub(sData, 5, 5))
    local nProtAddrLen = read_format(false, "1", string.sub(sData, 6, 6))
    local nOperation = read_format(false, "2", string.sub(sData, 7, 8))
    local nSrcHwAddr = read_format(false, "2", string.sub(sData, 9, 10))
    local nSrcProtAddr = read_format(false, "4", string.sub(sData, 11, 14))
    local nDestHwAddr = read_format(false, "2", string.sub(sData, 15, 16))
    local nDestProtAddr = read_format(false, "4", string.sub(sData, 17, 20))

    return { nHwType, nProtType, nHwAddrLen, nProtAddrLen, nOperation, nSrcHwAddr, nSrcProtAddr, nDestHwAddr, nDestProtAddr }, sData
end

function receiveMAC() -- OK
    local nSrcId, sData = rednet.receive()
    local sEvent

    local nType = read_format(false, "2", string.sub(sData, 1, 2))
    local sData = string.sub(sData, 3)

    if nType == MAC_PROTO_IP then
        sEvent = EVENT_IP
    elseif nType == MAC_PROTO_ARP then
        sEvent = EVENT_ARP
    end

    os.queueEvent(sEvent, { nSrcId, nType }, sData)

    return true
end

-- == Implementations ==

function ARPRequest(nDestAddr)
    sendARP(ARP_OP_REQUEST, 2^16, nDestAddr)
    -- Wait for response
end

function ARPResponse()
    -- Wait for request
    -- Send response
end

function ARPAnnounce()
    -- Send gratuitous ARP request
end
