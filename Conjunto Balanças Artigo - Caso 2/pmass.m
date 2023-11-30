% GERADOR DE DADOS DE MASSA APLICANDO A EQ. DE PRESSÃO

function m = pmass(p, t, A0original, lambdaoriginal, C, alpha, g)

% Função Pconst:
%   Especifica os parâmetros para a balança padrão e de teste

% Parâmetros de entrada:
%   p -->   Valores de pressão (MPa)
%   t --> Valores de temperatura (ºC)
%   A0 --> 
%   lambda -->
%   C -->
%   alpha --> parâmetros da balança teste (verificar PCONST)
%   g -->   Constante gravitacional (m/s^2)

%   Parâmetros de saída:
%   m --> Cargas aplicadas (kg) incluindo a correção da densidade do ar

%   Cargas aplicadas computadas do rearranjo da equação de pressão:

m = (A0original/g)*(p.*(1 + lambdaoriginal*p).*(1 + alpha*(t - 20))) - C;


