% GERADOR DE DADOS DOS PARÂMETROS DA BALANÇA

function [A0s, lams, Cs, alps, A0t, A0original, lamt, Ct, alpt, g, p, t, ts, tt, tt_, alpha, C, lambdaoriginal, w, n] = pconst_temp

% Função Pconst:
%   Especifica os parâmetros para a balança padrão e de teste

% Parâmetros de saída:
%   p --> Vetor de valores de pressão das balnças de teste e padrão
%   A0s, lams, Cs, alps --> Parâmetros da balança padrão
%   A0t, lamt, Ct, alpt --> Parâmetros da balança de teste
%   rhoa, g --> Densidade do ar e aceleração da gravidade

% Dados para funções Wllspe e Wllspec

% Definição do Range de pressão das balanças de teste e padrão (MPa) [Valor pode ser alterado]

p = [5.9998482; 11.999704; 17.9983626; 23.9975687; 29.9963096; 41.9920898; 53.9864002; 59.983944; 59.9839121; 41.9923577; 23.9977375; 12.0007186; 6.0015301; 6.0015222; 12.000095; 23.9979859; 41.9917222];

%Número de medições
n = length(p);

% Temperatura padrão da medição (ºC) [Valor pode ser alterado]

t = [18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28];

% Aceleração da gravidade (m/s^2) [Valor pode ser alterado]

g = 9.80662259;

% Valor do coeficiente de dilatação térmica linear da balança teste (1/ºC)

alpha = 0.000011;

% Valor da área efetiva da balança teste (mm^2)

A0original = 4.029770000000001;

% Coeficiente de distorção do conjunto da balança teste (1/MPa)

lambdaoriginal = 0.000004;

% Correção da carga aplicada da balança teste (kg)

C = 0.000009246;

% Peso dos valores de carga aplicada [PODE SER AJUSTADO]

w = 1;

%------------------------------------------------------------------------

% Dados para métodos p e delta-p 

% Dados da balança padrão [Valores podem ser alterados]:
%   - A0s --> Área do conjunto pistão-cilindro (mm^2)
%   - Lams --> Coeficiente de distorção do conjunto (1/MPa)
%   - Cs --> Correção da carga aplicada (kg)
%   - alps --> Coef. de dilatação térmica (1/ºC)
%   - ts --> Temperatura da balança

A0s = 8.065150000000001;
lams = 0.0000033;
Cs = 0.0000185;
alps = 0.000011;
ts = [18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28];

% Dados para a balança teste [Valores podem ser alterados]:

A0t = 4.029770000000001;
lamt = 0.000004;
Ct = 0.000009246;
alpt = 0.000011;
tt= [18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28];

%Valor de tt somente para o método dpmethod para criar um vetor

tt_= 23.37 * ones(size(p));
