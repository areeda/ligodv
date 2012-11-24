% if using a remote display on unix don't try to use hardware openGL
comp=computer;
disp = getenv('DISPLAY');

if (strcmp(comp,'GLNXA64') && ~strcmp(disp,':0.0'))
	opengl software
end
