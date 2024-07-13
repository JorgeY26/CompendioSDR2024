% Pedir al usuario que seleccione las imágenes a procesar
[archivos, carpetaOrigen] = uigetfile('*.png', 'Seleccione las imágenes a procesar', 'MultiSelect', 'on');

% Salir si el usuario cancela la selección
if isequal(archivos, 0) || isequal(carpetaOrigen, 0)
    disp('Selección cancelada por el usuario.');
    return;
end

% Pedir al usuario que seleccione la carpeta de destino
carpetaDestino = uigetdir('ruta/a/carpeta/destino', 'Seleccione la carpeta de destino para guardar las imágenes');

% Salir si el usuario cancela la selección
if isequal(carpetaDestino, 0)
    disp('Selección cancelada por el usuario.');
    return;
end

% Procesar cada imagen seleccionada
for i = 1:length(archivos)
    % Leer la imagen original
    rutaImagenOriginal = fullfile(carpetaOrigen, archivos{i});
    imagenOriginal = imread(rutaImagenOriginal);
    
    % Verificar las dimensiones de la imagen
    [alto, ancho, ~] = size(imagenOriginal);
    if alto ~= 240 || ancho ~= 940
        warning('La imagen %s no tiene dimensiones de 940x240 píxeles. Se omite.', archivos{i});
        continue;
    end
    
    % Dividir la imagen en 4 partes de 940x60 píxeles
    parte1 = imagenOriginal(1:60, :, :);      % Parte superior
    parte2 = imagenOriginal(61:120, :, :);    % Segunda parte superior
    parte3 = imagenOriginal(121:180, :, :);   % Segunda parte inferior
    parte4 = imagenOriginal(181:240, :, :);   % Parte inferior
    
    % Redimensionar las partes a 940x240 píxeles
    parte1_redimensionada = imresize(parte1, [240, 940]);
    parte2_redimensionada = imresize(parte2, [240, 940]);
    parte3_redimensionada = imresize(parte3, [240, 940]);
    parte4_redimensionada = imresize(parte4, [240, 940]);
    
    % Generar los nombres de los archivos de las nuevas imágenes
    [~, nombreArchivo, ~] = fileparts(archivos{i});
    nombreParte1 = fullfile(carpetaDestino, [nombreArchivo, '_parte1.png']);
    nombreParte2 = fullfile(carpetaDestino, [nombreArchivo, '_parte2.png']);
    nombreParte3 = fullfile(carpetaDestino, [nombreArchivo, '_parte3.png']);
    nombreParte4 = fullfile(carpetaDestino, [nombreArchivo, '_parte4.png']);
    
    % Guardar las partes redimensionadas como nuevas imágenes PNG
    imwrite(parte1_redimensionada, nombreParte1);
    imwrite(parte2_redimensionada, nombreParte2);
    imwrite(parte3_redimensionada, nombreParte3);
    imwrite(parte4_redimensionada, nombreParte4);
end

disp('Las imágenes redimensionadas se han guardado correctamente en la carpeta de destino.');
