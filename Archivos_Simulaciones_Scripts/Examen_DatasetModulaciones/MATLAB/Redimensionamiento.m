% Ruta de la carpeta con las imágenes originales
carpeta_original = 'C:\Users\USER\Desktop\dataset\carpeta';
archivos = dir(fullfile(carpeta_original, '*.png')); 

% Carpeta donde guardar las imágenes redimensionadas
carpeta_destino = 'C:\Users\USER\Desktop\dataset\carpeta2';
if ~isfolder(carpeta_destino)
    mkdir(carpeta_destino);
end

% Tamaño de redimensionamiento
ancho = 940;
alto = 240;

% Iterar sobre los archivos, redimensionar y copiar
for i = 1:length(archivos)
    nombre_archivo_original = archivos(i).name;
    ruta_original = fullfile(carpeta_original, nombre_archivo_original);
    imagen_original = imread(ruta_original);
    
    % Redimensionar la imagen
    imagen_redimensionada = imresize(imagen_original, [alto, ancho]);
    
    % Construir y guardar la ruta de destino
    ruta_destino = fullfile(carpeta_destino, nombre_archivo_original);
    imwrite(imagen_redimensionada, ruta_destino);
end

