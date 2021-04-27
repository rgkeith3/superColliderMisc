b = Buffer.readChannel(s, "/Users/greykeith/Downloads/I Can't Handle Change-R7IQ9dpxxJY.wav", channels: 1)

// in this example, i'm demonstrating using lower dimensions for spatialization, and a higher dimension for 'time' or the time in the sample. i'm just doing a 2d spatialization and using the third dimension for time, but you could use a similar effect with a 3d ambisonic spatialization and a 4th dimension time slider

(SynthDef(\timeboid, {|x=0, y=0, z=0, out=0, b=0|
	var sig;
	sig = Warp1.ar(1, b, z.linlin(-500, 500, 0, 1), windowSize: 0.2, overlaps: 4, windowRandRatio: 0.1);
	sig = HPF.ar(sig, y.linlin(-500, 500, 1, 5000));
	sig = Pan2.ar(sig, x.linlin(-500, 500, -1, 1));

	Out.ar(out, sig);
}).add)

(
f = Boids3D.new(10, 0.1);

~boids = Array.fill(10, {
	Synth(\timeboid, [\b, b]);
});

r = fork {
	loop {
		f.moveFlock({|flock|
			flock.boids.do {|boid, i|
				boid.vel.asCartesian.len;
				~boids[i].set(\x, boid.pos.x, \y, boid.pos.y, \z, boid.pos.z);
			}
		});
		0.1.wait;
	};
};
)
f.visualizer([0,1])
f.visualizer([0,2])

f.wrap = false
f.addTarget([0,0,0], 1)
f.editTarget(0, [0,0,0], 0.1)
f.centerInstinct = 0
f.innerDistance = -0.1
f.minSpace = 10
f.bounds
f.matchVelocity = 0.1
f.maxVelocity = 150