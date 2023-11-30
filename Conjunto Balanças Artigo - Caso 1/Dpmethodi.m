% MÉTODO-DELTAP UTILIZANDO OS DADOS DA I-ÉSIMA MEDIÇÃO

function [A0te_vec, lamte_vec, mte_dpmethodi] = Dpmethodi(p, tt_, mt, Ct, alpt, g)

% Função dpmethodi:
%   Simulação do Método-DeltaP utilizado para derterminar os parâmetros de área efetiva de
%   uma certa balança de teste, resolvendo um problema de mínimos quadrados
%   ponderados derivado da equação de pressão. Nesta versão, o termo de
%   correção Ct é removido implicitamente usando informações da i-ésima
%   edição

% Parâmetros de entrada:
%   p -->   Valores de pressão (MPa)
%   tt --> Valores de temperatura (ºC) para a balança teste
%   mt --> Cargas aplicadas (kg) para a balança teste
%   Ct -->
%   alpt --> Parâmetros da balança teste (verificar PCONST)
%   g -->   Constante gravitacional (m/s^2)

%   Parâmetros de saída:
%   A0te_vec, lamte_vec --> Vetores de parâmetros de área efetiva para balança teste
%   mte -->  Cargas aplicadas determinadas pela equação de pressão e por
%   estimativas da área efetiva

%   Número de medidas

num_measurements = length(p);

% Vetores para armazenar os valores de A0te e lamte

A0te_vec = zeros(num_measurements, 1);
lamte_vec = zeros(num_measurements, 1);

% Começa o loop

for i = 1:num_measurements

    %   Remove a i-ésima medição dos dados

    pb = p; pb(i) = [];
    tb = tt_; tb(i) = [];
    mb = mt; mb(i) = [];

    %   Matriz de observação ponderado

    dp = pb - p(i);
    sp = pb + p(i);
    w = ones(size(dp))./dp;
    A = [w.*dp  w.*dp.*sp];

    %   Vetor ponderado do lado direito

    y1 = (mb + Ct)./(1 + alpt.*(tb - 20));
    y2 = (mt(i) + Ct)./(1 + alpt.*(tt_(i) - 20));
    y = w.*(y1 - y2).*g;

    %   solução dos mínimos quadrdados

    b = A\y;

    % Extrai os parâmetros da área efetiva

    A0te = b(1);
    lamte = b(2)/b(1);

    % Armazena os resultados nos vetores
    A0te_vec(i) = A0te;
    lamte_vec(i) = lamte;
end

% Calcula os valores de carga aplicada que são determinados pela equação
% de pressão e por essas estimativas

mte_dpmethodi = pmass(p, tt_, A0te, lamte, Ct, alpt, g);

end
