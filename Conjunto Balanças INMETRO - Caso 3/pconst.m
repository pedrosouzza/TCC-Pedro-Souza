% GERADOR DE DADOS DOS PARÂMETROS DA BALANÇA

function [A0s, lams, Cs, alps, A0t, A0original, lamt, Ct, alpt, g, p, t, ts, tt, tt_, alpha, C, lambdaoriginal, w, n] = pconst

% Função Pconst:
%   Especifica os parâmetros para a balança padrão e de teste

% Parâmetros de saída:
%   p --> Vetor de valores de pressão das balnças de teste e padrão
%   A0s, lams, Cs, alps --> Parâmetros da balança padrão
%   A0t, lamt, Ct, alpt --> Parâmetros da balança de teste
%   rhoa, g --> Densidade do ar e aceleração da gravidade

% Dados para funções Wllspe e Wllspec

% Definição do Range de pressão das balanças de teste e padrão (MPa) [Valor pode ser alterado]

p = [8; 16; 24; 32; 40; 48; 56; 64; 72; 80];

%Número de medições
n = length(p);

% Temperatura padrão da medição da balança teste (ºC) [Valor pode ser alterado]

t = 28;

% Aceleração da gravidade (m/s^2) [Valor pode ser alterado]

g = 9.80665;

% Valor do coeficiente de dilatação térmica linear da balança teste (1/ºC)

alpha = 0.000011;

% Valor da área efetiva da balança teste (mm^2)

A0original = 4.90260942101015;

% Coeficiente de distorção do conjunto da balança teste (1/MPa)

lambdaoriginal = 0.00000000666323799234886;

% Correção da carga aplicada da balança teste (kg)

C = 0.0000025;

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

A0s = 4.90212;
lams = 0.00000000760000000000000;
Cs = 0.00000175;
alps = 0.000011;
ts = 28;

% Dados para a balança teste [Valores podem ser alterados]:

A0t = 4.90260942101015;
lamt = 0.00000000666323799234886;
Ct = 0.0000025;
alpt = 0.000011;
tt= 28;

%Valor de tt somente para o método dpmethod para criar um vetor

tt_= 28 * ones(size(p));
