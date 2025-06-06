ProxySpace.push(s.boot)


(~a = Routine({
	inf.do {
		[(freq: 400), (freq: 500), (freq: 600), (freq: 700)].do { |ev| ev.yield }
	}
}).asEventStreamPlayer)

(x = Routine({
	loop {
		(freq: 400).yield;
		(freq: 500).yield;
		(freq: 600).yield;
		(freq: 700).yield;
	}
}).asEventStreamPlayer)


// NoteStream would be routine under the hood
// keeping an multidimensional array of events
// maybe add the function that nodeproxy calls under the hood, to turn it into an event stream player
// .buildForProxy()
// NoteStream would have a .routine() function that will return the routine
// also implements .asEventStreamPlayer()
// but also keeps an event array, and that's what does operations
// NoteStreams have a length, and also can play n number of times (n can equal inf)
// they can also print their events in a way they can be re-ingested
(x = Routine({
	inf.do {
		[(freq: [400,350], sustain: [1, 2], dur: 1), (freq: 500, sustain: 0.5, dur: 2), (freq: 600, sustain: 0.1), (freq: 700, sustain: 1)].do { |ev| ev.yield; }
	}
}).asEventStreamPlayer)

(x = Routine({
	inf.do {
		[(degree: 5)].do { |ev| ev.yield; }
	}
}).asEventStreamPlayer)


x.play
x.func_({inf.do { (freq: 400).yield;}})
x.archiveAsCompileString

x.generate({})
Event.default.play
s.boot

Quarks.install("~/supercollider/NotePhrase/")
s.boot


w.sorted
x = NotePhrase(grid: 2)
y = NotePhrase(4, 1);
y.play
x.shift(5);
y.shift(time: 0.5)
x.sorted[0].value.notes

x.play
x.noteDict[].notes
x.layer(y)
x.play


x.put(0.5, (degree: 4, sustain: 1))

y.shift(time: 0.5)
y = NotePhrase(3, 1/2)
x.layer(y)
x.noteDict
x.play
x.sorted
x.play
y = NotePhrase(grid: 2)
y.play
x.layer(y)
x.play

x.eventList.noteDict

x.eventList.noteDict.sortedKeysValuesDo({|key, value| value.postln})
x.eventList.sorted
x.play

x.eventList.noteDict.values.do{|ev| ev.start.postln;}
x.eventList.noteDict
x.eventList.noteDict

z = NotePhrase(grid: 2)
w = NotePhrase(grid: 2)
NotePhrase.methods.do {|m| m.findReferences.postln}
x.perform(\onsets)
a = LazyEnvir.new
a.proxyClass = \Set
x.play(1)
y.play(1)
x = x.layer(y).layer(z).layer(w)
x.play()
x.timeline
x.timeline
x.scramble
[1,2,3][1..2]
b = 3
a = 0 -> ()
a.value
b = [1,2,3][1..(2-1)]
b = [(degree: 1),(degree: 2)]
a = (degree:4).at(\dur, 1)
(degree: 4).put(\dur, 1).play
[(degree: 5), (degree: 3), (degree: 4)].collect{|ev|ev.asPairs}.flatten.asEvent().play
a = Set.newFrom(b)
a
a.collect{|note|
	note[\degree] = note[\degree] + 2;
}


(degree: [1,2], scale: [Scale.major, Scale.minor]).play
a.asArray.collect {|event| event.asKeyValuePairs}.asEvent({|