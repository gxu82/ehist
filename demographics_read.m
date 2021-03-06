function dem = demographics_read(filename)
% dem = demographics_read(filename)
%   Read a Babel demographics file.  Return a structure
%   dem.{outputFn,sessID,date,time,spkrCode,lineType,dialect,gen,envType,age,network,phoneModel}
%   each as cell arrays with corresponding entries per file.
% 2014-01-03 Dan Ellis dpwe@ee.columbia.edu

[m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,sampleCount,sampleRate] = ...
    textread(filename, ...
             '%s%s%s%s%s%s%s%s%s%s%s%s%s%s','whitespace','\t');

% first line is header, skip it
for i = 2:length(m1)
  ix = i-1;
  % convert name to all lower case and remove file extension
  opfn = lower(m1{i});
  lastdot = max(find(opfn == '.'));
  dem.outputFn{ix}  = opfn(1:lastdot-1);
  dem.sessID{ix}    = m2{i};
  dem.date{ix}      = m3{i};
  dem.time{ix}      = m4{i};
  dem.spkrCode{ix}  = m5{i};
  dem.lineType{ix}  = m6{i};
  dem.dialect{ix}   = m7{i};
  dem.gen{ix}       = m8{i};
  dem.envType{ix}   = m9{i};
  dem.age{ix}       = m10{i};
  dem.network{ix}   = m11{i};
  dem.phoneModel{ix} = m12{i};
end

% Calculate a map of dialects
[dem.dialectCodes.names, xx, dem.dialectCodes.code] = ...
    unique(dem.dialect);

% Calculate a map of genders
[dem.genders.names, xx, dem.genders.code] = ...
    unique(dem.gen);

% Calculate a map of phone networks
[dem.networks.names, xx, dem.networks.code] = ...
    unique(dem.network);

% Calculate a map of conditions
[dem.envTypes.names, xx, dem.envTypes.code] = unique(dem.envType);

% Make abbreviations
dem.envTypes.abbrev = make_abbrev(dem.envTypes.names);

% sorted by descending mean WER over all BP1 DEV sets
%mycodes = {'S', 'PP', 'HOM', 'V', 'CK', 'HOL', 'M'};
% sorted by descending median WER over all BP1 DEV sets
mycodes = {'CK', 'V', 'PP', 'S', 'HOM', 'HOL', 'M'};
for i = 1:length(dem.envTypes.abbrev)
  % cmap(i) is the position of names{i} in mycodes
  cmap(i) = strmatch(dem.envTypes.abbrev{i}, mycodes);
end
% re-index
dem.envTypes.names(cmap) = dem.envTypes.names;
dem.envTypes.abbrev(cmap) = dem.envTypes.abbrev;
dem.envTypes.code = cmap(dem.envTypes.code);
