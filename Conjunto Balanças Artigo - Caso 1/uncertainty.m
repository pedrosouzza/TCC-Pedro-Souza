% CÁLCULO DE INCERTEZAS

function [u_Ap_combinada_values, u_Ap_expandida_values, p_PA] = uncertainty

% Método B Escolhido

% Definição das variáveis:

p_PA = [5999848.2; 11999704; 17998362.6; 23997568.7; 29996309.6; 41992089.8; 53986400.2; 59983944; 59983912.1; 41992357.7; 23997737.5; 12000718.6; 6001530.1; 6001522.2; 12000095; 23997985.9; 41991722.2]; % Range de pressão da balança de teste (Pa)
p_MPa = [6; 12; 18; 24; 30; 41; 54; 60; 60; 42; 24; 12; 6; 6; 12; 24; 42]; % Range de pressão da balança de teste (MPa)
Soma_p = sum (p_PA); % Soma dos elementos do vetor P (Pa)
Soma_p_MPa = sum(p_MPa); % Soma dos elementos do vetor P (MPa)
N = length (p_PA); % Número de pontos calibrados
mr = [4.93502; 9.87023; 14.80467; 19.73974; 24.67461; 34.54347; 44.41209; 49.34652; 49.34632; 34.54347; 19.73964; 9.87093; 4.93632; 4.93632; 9.87043; 19.73984; 34.54297]; % Valores de massa (Kg)
msoma = sum(mr); % Somatório das massaas do sistem - Balança de teste
mx = 12.3287407; % Valor de massa para P = 30 MPa
u_mr = 0.000009246; % Somatório da incertezas das massas do sistema - Balança teste
rhoa = 1.15; % Massa específica do ar (kg/m³)
rhomr = 7900; % Massa específica das massas (Kg/m³)
rhof = 915; % Massa específica do fluido utilizado (Kg/m³) [Valor da nossa balança não achei esse dado no artigo]
g = 9.80662259; % Aceleração da gravidade local em Zagreb na Croácia (m/s²)
sigma = 0.03; % Tensão superficial do fluido (N/m)
C = 0.007116352547187880344; % Comprimento da circunferência do pistão da balança Teste (m)
alphac = 0.000011; % Coeficiente de expansão térmica linear do cilindro (1/ºC)
alphap = 0.000011; % Coeficiente de expansão térmica linear do pistão (1/ºC)
t = 23.37; % Temperatura do pistão no momento da medição (ºC)
tr = 20; % Temperatura de referência
deltah = 0.0033; % Desnível entre os conjuntos pistão-cilindro´(m)
u_deltah = 0.0015; % Incerteza do desnível entre os conjuntos pistão-cilindro´(m)
%------------------------------------------------------------------------------------------------------------------------------

% Cálculo das áreas efetivas, coeficiente de distorção e as incertezas
% padrão tipo A

% Cálculo das Áreas Efetivas

A0 = zeros(size(p_PA)); % Inicializa um vetor de zeros para armazenar os valores de A0

for i = 1:length(p_PA)
    
    A0(i) = ((mr(i) * (1 - rhoa/rhomr)) * g + (sigma * C)) /((p_PA(i) + (rhof - rhoa) * g * deltah) * (1 + (alphac + alphap) * (t - tr)));

end

Soma_A0 = sum(A0); % Calcula a soma dos valores de A0 (m²)
Soma_A0_m_2 = sum(A0) * 1e+6; % Calcula a soma dos valores de A0 (mm²)

p_A0 = p_PA .* A0;
Soma_p_A0 = sum (p_A0); % Valor em Pa*m²

% Considera-se que a área efetiva é linearmente dependente da pressão

% Cálculo da Área Efeiva

%A0_Unica = ((Soma_p^2 * Soma_A0 ) - (Soma_p * Soma_p_A0))/(N * Soma_p^2 - (Soma_p)^2); %  Fórmula para Área Efetiva em m²
A0_Unica = 0.00000402977; % Área Efetiva da balança teste do artigo (m²)

% Cálculo do Coeficiente de Distorção

teta_1 = ((N * Soma_p_A0) - (Soma_p * Soma_A0))/((N * Soma_p^2) - (Soma_p)^2); % m²/Pa (Número dando negativo, pode isso?)
teta_1_real = abs(teta_1);

%lambda_Unica = teta_1/A0_Unica; % Fórmula para Coeficiente de distorção (1/Pa)
lambda_Unica = 4; % Coef. Distorção da balança teste do artigo (1/Pa)

% Cálculo das incertezas Padrão do tipo A

Subtracao_grande = sum((A0 - A0_Unica - (teta_1 .* p_PA)).^2);
Soma_Subtracao_grande = sum(Subtracao_grande);

V_A0 = (Soma_p^2 / ((N * Soma_p^2) - (Soma_p)^2)) * (Soma_Subtracao_grande / (N - 2)); % Variância da Área Efetiva (m^4)

V_teta_1 = (N / ((N * Soma_p^2) - (Soma_p)^2)) * (Soma_Subtracao_grande / (N - 2)); % Variância de teta_1 (m^4 * Pa^-2)

Cov_A0_teta_1 = ((-Soma_p^2) / (N * Soma_p^2 - (Soma_p)^2)) * (Soma_Subtracao_grande / (N - 2)); % Covariância da Área Efetiva e de Teta 1 (m^4 * Pa^-1)

Cov_A0_teta_1_abs = abs(Cov_A0_teta_1);

Ua_A0_Unica = sqrt(N * V_A0); % Incerteza padrão do tipo A da Área Efetiva (m²)

Ua_lambda = sqrt(N * V_teta_1)/A0_Unica; % Incerteza padrão do tipo A do Coef. Distorção (1/Pa)

% Valor da pressão (Pa) para cálculo da incerteza [PODE SUBSTITUIR]
p_Unico = p_PA; 

Ua_A0_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de Ua_A0

for i = 1:length(p_PA)
    Ua_A0_values(i) = sqrt(N) * (sqrt(V_A0 + V_teta_1 * (p_PA(i))^2 + (2 * Cov_A0_teta_1_abs * p_PA(i)))); % Incerteza padrão do tipo A da área em função da pressão (m²)
end

% Cálculo das incertezas Padrão do tipo B

% Incerteza da pressão gerada pela balança de referência

u1_Ap_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de u1_Ap

for i = 1:length(p_PA)
    u1_Ap_values(i) = (sqrt(N) * (sqrt(V_A0 + V_teta_1 * (p_PA(i))^2 + 2 * Cov_A0_teta_1_abs * p_PA(i))))/2*p_PA(i); % Incerteza padrão do tipo B da área em função da pressão (m²)
end

% Incerteza da massa

u2_Ap = u_mr/(2 * mx);

% Incerteza da temperatura do conjunto pistão-cilindro

u3_Ap = (alphap + alphac) * 0.5/sqrt(3);

% Incerteza do coeficiente de expansão térmica do conjunto pistão-cilindro

u4_Ap = (abs(t - tr) * (alphap + alphac) * 0.1)/2;

% Incerteza da aceleração da gravidade local

u5_Ap = 0.00004/3;

% Incerteza da densidade do ar

u6_Ap = ((msoma/rhomr)/msoma) * (0.005 * rhoa/2);

% Incerteza da densidade dos pesos

u7_Ap = 0; % Não tem variação significativa na densidade do ar

% Incerteza da diferença de altura

u8_Ap_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de u8_Ap

for i = 1:length(p_PA)

    u8_Ap_values(i) = ((rhof * g) / p_PA(i)) * (u_deltah / 2);

end

% Incerteza da densidade do fluido transmissor de pressão

u9_Ap_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de u9_Ap

for i = 1:length(p_PA)

    u9_Ap_values(i) = ((g * deltah)/p_PA(i)) * ((0.02 * rhof)/2);

end

% Incerteza da tensão superficial do fluido transmissor de pressão

u10_Ap_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de u10_Ap

for i = 1:length(p_PA)

    u10_Ap_values(i) = (2/p_PA(i)) * (sqrt(pi/A0_Unica)) * ((0.1 * sigma)/2);

end

% Incerteza da inclinação do pistão

u11_Ap = 0; % Considerando que o pistão é perfeitamente perpendicular

% Incerteza Padrão relativa do tipo B

uB_Ap_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de incerteza padrão relativa do tipo B

for i = 1:length(p_PA)

    uB_Ap_values(i) = sqrt(((u1_Ap_values(i).^2 + u2_Ap^2 + u3_Ap^2 + u4_Ap^2 + u6_Ap^2 + u7_Ap^2 + u8_Ap_values(i).^2 + u9_Ap_values(i).^2 + u10_Ap_values(i).^2 + u11_Ap^2)) - (u5_Ap^2));

end

% Incerteza combinada da Área Efetiva

u_Ap_combinada_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de incerteza combinada

for i = 1:length(p_PA)

    u_Ap_combinada_values(i) = sqrt(Ua_A0_values(i)^2 + uB_Ap_values(i)^2);

end

% Incerteza Expandida da Área efetiva

%u_Ap_expandida_values = zeros(size(p_PA)); % Inicializa o vetor para armazenar os valores de incerteza combinada

u_Ap_expandida_values = zeros(size(p_PA));

for i = 1:length(p_PA)

    u_Ap_expandida_values(i) = 2 .* u_Ap_combinada_values(i);
end