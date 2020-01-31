s.boot

n = NetAddr("localhost", 10000)

n.sendMsg("/part/wind/x", 0)
n.sendMsg("/part/wind/y", 0)
n.sendMsg("/part/turb/y", 1)
n.sendMsg("/part/turb/z", 1)
n.sendMsg("/part/turb/x", 1)
n.sendMsg("/part/turb/period", 5)
n.sendMsg("/part/turb/seed", 3)
n.sendMsg("/part/wind/z", 0)
n.sendMsg("/part/birth", 100)
n.sendMsg("/cam/translate/z", 5);n.sendMsg("/cam/translate/x", 0.5);n.sendMsg("/cam/translate/y", 0.5); n.sendMsg("/cam/translate/speed", 1)
n.sendMsg("/cam/rotate/z", 5);n.sendMsg("/cam/rotate/x", 5);n.sendMsg("/cam/rotate/y", 5);
n.sendMsg("/cam/rotate/speed", 0.1)
n.sendMsg("/cam/rotate/z/speed", 0)

n.sendMsg("/cam/rotate/y/speed", 10);n.sendMsg("/cam/rotate/x/speed", 10)

n.sendMsg("/sprite/x", 0.5)
n.sendMsg("/sprite/y", 0.5)

// messages
// /part
//   -> /wind
//      -> /x
//      -> /y
//      -> /z
//   -> /turb
//      -> /x
//      -> /y
//      -> /z
//      -> /period
//      -> /seed
//   -> /birth
// /cam
//   -> /translate
//      -> /x
//      -> /y
//      -> /z
//      -> /speed
//   -> /rotate
//      -> /x
//      -> /y
//      -> /z
//        -> /speed
//      -> /speed

p = ProxySpace.push(s.boot)

~a = Pbind(\pan, Pwhite(-1.0))
~a.play