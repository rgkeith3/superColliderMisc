(

var nanoKontrolIn, nanoKontrolOut;
MIDIClient.init;
MIDIIn.connectAll;

nanoKontrolIn = MIDIClient.sources.select({|endPoint| endPoint.device == "nanoKONTROL2" && endPoint.name == "SLIDER/KNOB"})[0];

nanoKontrolOut = MIDIOut.newByName("nanoKONTROL2", "CTRL");

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