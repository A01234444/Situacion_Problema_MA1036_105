% ANÁLISIS DE COMPONENTES PRINCIPALES (PCA) - PROCEDIMIENTO COMPLETO

% PREPARACIÓN DE LOS DATOS
clear all
clc
% Cargar los datos desde el archivo Excel
T = readtable('datos_PCA_30_empleados_5_indicadores.xlsx');

% Extraer nombres de empleados y la matriz de datos numéricos (Columnas 2 a 6)
empleados = T{:, 1};
X = T{:, 2:6}; 
nombres_indicadores = T.Properties.VariableNames(2:6);

% Centrar los datos (restar la media a cada columna)
X_centrada = X - mean(X);

% PASO 1: Matriz de varianzas y covarianzas
% Generar la matriz S a partir de los datos centrados
S = cov(X_centrada);

disp('RESULTADO PASO 1');
disp('Matriz de Varianzas y Covarianzas (S):');
disp(S);


% PASO 2: Determinar los valores y vectores propios de S
% eig() devuelve vectores propios (V) y valores propios en la diagonal (D)
[V, D] = eig(S);

disp('RESULTADO PASO 2');
disp('Valores propios (Diagonal de la matriz D):');
disp(D);
disp('Vectores propios (Columnas de la matriz V):');
disp(V);



% PASO 3: Localizar el mayor valor propio y el vector propio asociado
% Extraer los valores propios y encontrar el máximo
valores_propios = diag(D); 
[mayor_valor_propio, indice_max] = max(valores_propios);

% Extraer el vector propio correspondiente al índice del mayor valor propio
vector_propio_asociado = V(:, indice_max);

disp('RESULTADO PASO 3');
disp('Mayor valor propio:');
disp(mayor_valor_propio);
disp('Vector propio asociado:');
disp(vector_propio_asociado);



% PASO 4: Jerarquizar a los empleados (Basado en el indicador de mayor peso)
% Encontrar el valor máximo absoluto en el vector propio principal
[max_peso, indice_indicador_top] = max(abs(vector_propio_asociado));
nombre_indicador_top = nombres_indicadores{indice_indicador_top};

disp('RESULTADO PASO 4');
disp(['El indicador con mayor peso es: ', nombre_indicador_top]);

% Extraer los datos originales solo de ese indicador específico
datos_indicador_top = X(:, indice_indicador_top);

% Crear tabla y ordenar de mayor a menor según este indicador
Resultados = table(empleados, datos_indicador_top, ...
    'VariableNames', {'Empleado', nombre_indicador_top});
Resultados_Ordenados = sortrows(Resultados, nombre_indicador_top, 'descend');

disp('Clasificación final de empleados:');
disp(Resultados_Ordenados);



% Gráfica Scree Plot (Gráfico de Sedimentación)
% Ordenar valores propios de mayor a menor para la gráfica
valores_propios_ordenados = sort(valores_propios, 'descend');

% Generar la figura
figure;
plot(1:length(valores_propios_ordenados), valores_propios_ordenados, 'b-o', ...
    'LineWidth', 4, 'MarkerSize', 10, 'MarkerFaceColor', 'r');
title('Scree Plot', 'FontSize', 24, 'FontWeight', 'bold');
xlabel('Número de Componente', 'FontSize', 22);
ylabel('Valor Propio', 'FontSize', 22);
grid on;
xticks(1:length(valores_propios_ordenados));