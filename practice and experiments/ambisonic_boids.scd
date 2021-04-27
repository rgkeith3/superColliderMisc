s.boot

a = RealVector3D[50, 250, -150]

// deriving spherical coordinates for use in ambisonic panning from cartesian 3d coordinates
// RealVectors come from boids3d
a.asCartesian.asSpherical.theta

(SynthDef(\boid, {|rho=0, theta=0, phi=0, out=0|
		var sig, closeness;
	closeness = rho.linlin(0, 1000, 1, 0);
	sig = FoaEncode.ar(Saw.ar(closeness * 1000, closeness), FoaEncoderMatrix.newOmni());
		sig = FoaFocus.ar(sig, pi/2, theta, phi);
		Out.ar(out, sig);
}).add)

(SynthDef(\monitor, {|in|
	var sig = FoaDecode.ar(In.ar(b, 4), FoaDecoderMatrix.newStereo());
	Out.ar(0, sig);
}).add)


b = Bus.audio(s, 4);

// x = Synth(\boid, [\angle, 50, \out, b])
// x.set(\angle, 500)
// x.set(\theta, 1.5)
// x.free
b.scope

f = Boids3D.new(10, 0.1);
f.maxVelocity = 150;
(
~boids = Array.fill(10, {
	Synth(\boid, [\out, b]);
});

r = fork {
	loop {
		f.moveFlock({|flock|
			flock.boids.do {|boid, i|
				var spherical = boid.pos.asCartesian.asSpherical;
				~boids[i].set(\rho, spherical.rho, \theta, spherical.theta, \phi, spherical.phi);
			}
		});
		0.1.wait;
	};
};

x = Synth(\monitor, [\in, b], addAction: 'addToTail');
)

// probably worth implementing using RedBoid (seems to have better control over params)