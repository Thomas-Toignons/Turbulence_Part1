function data = read_file(filename)
    if isfile(filename)
        fileID = fopen(filename,'r');
        data = fscanf(fileID,'%f');
        fclose(fileID);
    else
        error('The specified file cannot be found.');
    end
end