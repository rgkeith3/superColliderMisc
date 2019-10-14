s.boot;

~b0 = Buffer.read(s, "/Volumes/CPG Utility/HACKED/Edit/Audio/metal/Clean Metal Hit 1.wav");

~b0.play;

~b0.zero;

~b0.read("/Volumes/CPG Utility/HACKED/Edit/Audio/metal/Clean Metal Hit 3.wav");

~b0.play;

~b0.numFrames;
~b0.numChannels;

~b0.bufnum;

~b1 = Buffer.readChannel(x, "/Volumes/CPG Utility/HACKED/Edit/Audio/metal/Clean Metal Hit 3.wav", channels: 1);

~b1.numChannels

s.sampleRate

~b1.sampleRate

