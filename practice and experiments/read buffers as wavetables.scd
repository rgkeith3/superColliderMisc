s.boot

f = SoundFile.openRead("/Users/greykeith/superCollider/utils/wavetables/AKWF_birds/AKWF_birds_0008.wav");
a = FloatArray.newClear(f.numFrames);
f.readData(a);
f.close
a.size // 600 -> must be power of 2 for wavetable
2.pow(9)
a = a.resamp1(2.pow(9))
a = a.as(Signal)
a = a.asWavetable

b = Buffer.loadCollection(s, a);

{Osc.ar(b, MouseY.kr(50, 5000))}.play
