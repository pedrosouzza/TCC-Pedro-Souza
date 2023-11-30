% GERADOR DE DADOS DE MASSA APLICANDO A EQ. DE PRESSÃO NO MÉTODO P

function [ms,mt] = mpmass(p, g, A0t, A0s, lams, lamt, alps, alpt, ts, tt, Cs, Ct)

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

%   Cargas aplicadas computadas do rearranjo da equação de pressão
%   (P e Deltapmethod)

ms = (A0s/g)*(p.*(1 + lams*p).*(1 + alps*(ts - 20))) - Cs;
mt = (A0t/g)*(p.*(1 + lamt*p).*(1 + alpt*(tt - 20))) - Ct;
