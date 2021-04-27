(play: {currentEnvironment.postln;}, test: "helo").play
// want to store a global scale per proxy space, and have events refer to that by adding a parent type that searches its parent env for a scale var but i don't think events are aware of what environment they're in


p.proto = (scale: Scale.major)
p

currentEnvironment

Ndef(\pat, Pbind(\dur, 1/4))
Ndef(\pat).play

p.envir[\scale] = Scale.minorPentatonic
// using p.envir accesses the environment that holds the vars directly so it skips the creation of node proxies
// you can still access the env vars like ~scale
currentEnvironment.envir[\scale]
currentEnvironment.envir[\noteDefaults] = (root: 5, mtranspose: 2, scale: Scale.minor)
currentEnvironment.envir[\this] = currentEnvironment
~noteDefaults
p[\scale]

~a = Pbind(\degree, Pseq([1,2,3,4,5], inf), \scale, ~scale)

~this[\scale]
// should write a method for proxyspace -> putVar that puts a variable without instantiating a node proxy.
// and should take a look at proxyspace put method that creates a node proxy for patterns and insert ~thisEnv in the eventStream so that we can access the noteDefaults