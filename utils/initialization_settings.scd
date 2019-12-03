 // settings file

// quad
(
s = Server.local;
ServerOptions.devices;
s.options.outDevice_("UMC404HD 192k");
s.options.inDevice_("UMC404HD 192k");
~numChannels = 4;
s.options.numOutputBusChannels_(~numChannels);
s.options.numInputBusChannels_(~numChannels);
s.options.memSize_(2.pow(20))
)

// stereo umc404
(
s = Server.local;
ServerOptions.devices;
s.options.outDevice_("UMC404HD 192k");
s.options.inDevice_("UMC404HD 192k");
~numChannels = 2;
s.options.numOutputBusChannels_(~numChannels);
s.options.numInputBusChannels_(~numChannels);
s.options.memSize_(2.pow(20))
)


(
// regular I/O
s.options.memSize_(2.pow(20))
s

)
// load samples
(
var sampleFolder;
var recurseFolder;
var readFiles;
~samples = ();

sampleFolder = PathName.new(thisProcess.nowExecutingPath).parentPath +/+ PathName("samples");

readFiles = {
	|files|
	var fileArray = [];
	files.do({
		|file|
		var buf = Buffer.readChannel(s, file.fullPath, channels: 1);
		fileArray = fileArray ++ [buf];
	});
	fileArray;
};

recurseFolder = {
	|entry, dictionary|
	entry.postln;
	if (entry.folders.size > 0) {
		var folder = ();
		entry.folders.do({
			|subFolder|
			recurseFolder.value(subFolder, folder);
		});
		dictionary.put(entry.folderName.asSymbol, folder);
	} {
		dictionary.put(entry.folderName.asSymbol, readFiles.value(entry.files));
	}
};

sampleFolder.entries.do({ |entry|
	entry.postln;
	recurseFolder.value(entry, ~samples)
});
)


