s.reboot
(
var sf;
// path to a sound file here
p = "/Users/greykeith/Downloads/drum_loop.wav";
// the frame size for the analysis - experiment with other sizes (powers of 2)
f = 2048;
// the hop size
h = 0.5;
// get some info about the file
sf = SoundFile.new( p );
sf.openRead;
sf.close;
// allocate memory to store FFT data to... SimpleNumber.calcPVRecSize(frameSize, hop) will return
// the appropriate number of samples needed for the buffer
y = Buffer.alloc(s, sf.duration.calcPVRecSize(f, h));
// allocate the soundfile you want to analyze
z = Buffer.readChannel(s, p, channels: [0]);
)

(
SynthDef("pvrec", { arg recBuf=1, soundBufnum=2;
    var in, chain, bufnum;
    bufnum = LocalBuf.new(2048, 1);
    Line.kr(1, 1, BufDur.kr(soundBufnum), doneAction: 2);
    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 0, doneAction: 2);
    // note the window type and overlaps... this is important for resynth parameters
    chain = FFT(bufnum, in, 0.25, 1);
    chain = PV_RecordBuf(chain, recBuf, 0, 1, 0, 0.5, 1);
    // no ouput ... simply save the analysis to recBuf
    }).add;

a = Synth("pvrec", [\recBuf, y, \soundBufnum, z]);
)

(
x.free; x = {
	var chain = LocalBuf(2048);
	chain = PV_BufRd(chain, y, Rand());
	chain = PV_RandComb(chain, MouseY.kr, MouseX.kr > 0.5);
	Out.ar(0, IFFT(chain, 1)!2);
}.play;
)

(
SynthDef(\pv_grain, {
	var sig, chain = LocalBuf(2048);
	chain = PV_BufRd(chain, \playBuf.kr(0), \pos.kr(0));
	chain = PV_RandComb(chain, \wipe.kr(0.95));
	sig = IFFT(chain, 1) * Env(times: [\atk.kr(0.1), \rel.kr(0.1)], curve: -4).ar(2);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).play;
)

(
~x = Bus.control;
~y = Bus.control;
)
(
x.free; x = {Out.kr(~x, MouseX.kr); Out.kr(~y, MouseY.kr);}.play;

z.stop; z = Routine({
	var pos = 0;
	loop {
		var dur;
		if (pos > 2, {pos = 0});
		Synth(\pv_grain, [\playBuf, 0, \pos, pos.linlin(0, 2, 0, 1), \atk, 0.1, \rel,1, \wipe, ~y.getSynchronous, \pan, 1.0.rand2]);
		dur = 0.05.rand;
		pos = pos + dur;
		dur.wait;
	};
}).play
)
y.bufnum

1.0.rand2