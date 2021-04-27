



MIDIClient.init
MIDIIn.connectAll;
MIDIFunc.noteOff({|val, num, chan, src| [val, num, chan, src].postln})

s.boot

r=MIDIOut.newByName("nanoKONTROL2", "CTRL")
r.control(0, ctlNum: 40, val: 0)

MIDIClient.destinations

s.options.numControlBusChannels
MIDIClient.sources[0].name

s.boot
(
var nanoKontrolIn, nanoKontrolOut, lpkIn;
MIDIClient.init;
MIDIIn.connectAll;

nanoKontrolIn = MIDIClient.sources.select({|endPoint| endPoint.device == "nanoKONTROL2" && endPoint.name == "SLIDER/KNOB"})[0];

nanoKontrolOut = MIDIOut.newByName("nanoKONTROL2", "CTRL");

lpkIn = MIDIClient.sources.select({|endPoint| endPoint.device == "LPK25" && endPoint.name == "LPK25"})[0];

m = (
	slider: Array.fill(8, {|i|
		var b, m;
		b = Bus.control(s);
		m = MIDIFunc.cc({|val| b.set(val / 127);}, i, 0, nanoKontrolIn.uid);
		m.permanent = true;
		b;}),
	knob: Array.fill(8, {|i|
		var b, m;
		b = Bus.control(s);
		m = MIDIFunc.cc({|val| b.set(val / 127);}, i + 8, 0, nanoKontrolIn.uid);
		m.permanent = true;
		b;}),
	s: Array.fill(8, {|i|
		var b, m, ccNum;
		ccNum = i + 16;
		b = Bus.control(s);
		m = MIDIFunc.cc({|val|
			if (val > 0) {
				if (b.getSynchronous > 0) {
					b.set(0);
					nanoKontrolOut.control(0, ctlNum: ccNum, val: 0);
				} {
					b.set(1);
					nanoKontrolOut.control(0, ctlNum: ccNum, val: 127);
				};
			};
		}, ccNum, 0, nanoKontrolIn.uid);
		m.permanent = true;
		b;}),
	m: Array.fill(8, {|i|
		var b, m, ccNum;
		ccNum = i + 24;
		b = Bus.control(s);
		m = MIDIFunc.cc({|val|
			if (val > 0) {
				if (b.getSynchronous > 0) {
					b.set(0);
					nanoKontrolOut.control(0, ctlNum: ccNum, val: 0);
				} {
					b.set(1);
					nanoKontrolOut.control(0, ctlNum: ccNum, val: 127);
				};
			};
		}, ccNum, 0, nanoKontrolIn.uid);
		m.permanent = true;
		b;}),
	r: Array.fill(8, {|i|
		var b, m, ccNum;
		ccNum = i + 32;
		b = Bus.control(s);
		m = MIDIFunc.cc({|val|
			if (val > 0) {
				if (b.getSynchronous > 0) {
					b.set(0);
					nanoKontrolOut.control(0, ctlNum: ccNum, val: 0);
				} {
					b.set(1);
					nanoKontrolOut.control(0, ctlNum: ccNum, val: 127);
				};
			};
		}, ccNum, 0, nanoKontrolIn.uid);
		m.permanent = true;
		b;}),
);
)

[1,2,3].select({|el| el == 2;})

m[\s][0].getSynchronous
s.boot

(
{
	var sig;
	sig = Pulse.ar((In.kr(m[\slider][0].index).lag * 1000), In.kr(m[\knob][0].index).lag);
	sig = RLPF.ar(sig, In.kr(m[\slider][1].index).lag * 10000 + 1, In.kr(m[\knob][1]).lag + 0.001);
	sig = Pan2.ar(sig, In.kr(m[\knob][2]) * 2 - 1, In.kr(m[\slider][2]).lag);
	sig;
}.play
)

MIDIClient.sources

MIDIdef()