clc
clear
close all

%%
% Script pour exécuter tous les fichiers .m du dossier courant
files = dir('*.m');

[~, currentScript] = fileparts(mfilename('fullpath'));

for k = 1:length(files)
    files = dir('*.m');
    [~, currentScript] = fileparts(mfilename('fullpath'));
    [~, name, ext] = fileparts(files(k).name);

    % Ignorer ce script lui-même
    if strcmp(name, currentScript)
        continue;
    end

    % Affiche une boîte de dialogue avant d'exécuter le script
    h= msgbox(['Exécution de : ', files(k).name], 'Exécution en cours');
    pause(1.5); % Pause pour permettre de lire le message

    try
        run(files(k).name);
        if isvalid(h), close(h); end
    catch ME
        msgbox(['Erreur dans : ', files(k).name, newline, ME.message], 'Erreur', 'error');
    end
end
