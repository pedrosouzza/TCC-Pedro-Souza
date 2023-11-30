 %TESTE PROGRAMA MAIN_WLLSPEC

% Chama a função pconst para obter os parâmetros
[A0s, lams, Cs, alps, A0t, A0original, lamt, Ct, alpt, g, p, t, ts, tt, tt_, alpha, C, lambdaoriginal, w, n] = pconst;

% Agora com os valores dos parâmetros, e pode usá-los para chamar a função pmass
m = pmass(p, t, A0original, lambdaoriginal, C, alpha, g);

% Chama a função Wllspec
[A0_wllspec, lambda_wllspec, C_wllspec, me_wllspec] = Wllspec(p, t, m, w, alpha, g);

% Cálculo do erro das massas da balança teste

for i = 1:n
    soma = vpa ((me_wllspec(i) - m(i))^2);
end

EM_wllspec = vpa(1/n * sqrt(soma));

% Verifica se as variáveis dos erros são nulas e atribui o valor zero

if EM_wllspec == 0
    EM_wllspec = 0;
end

%------------------------------------------------------------------------------------------------------------------

% Nome da pasta de trabalho no Excel
workbookName = 'Pressao_e_massa_input_wllspec.xlsx';

% Defina os dados que você deseja exportar
inputData = table(p', m', me_wllspec', 'VariableNames', {'Pressao (MPa)', 'Massa Original (Kg)', 'Massa Estimada (Kg)'});
inputData_transposta = table(p, m, me_wllspec, 'VariableNames', {'Pressao (MPa)', 'Massa Original (Kg)', 'Massa Estimada (Kg)'});
resultsData = table(A0original, A0_wllspec, lambdaoriginal, lambda_wllspec, EM_wllspec, 'VariableNames', {'Área Efetiva Original (mm²)','Área Efetiva Estimada (mm²)', 'Coef. Distorção Original (1/MPa)', 'Coef. Distorção Estimado (1/MPa)', 'Erro na massa (Kg)'});

% Exporte os dados para a pasta de trabalho no Excel
writetable(inputData_transposta, workbookName, 'Sheet', 'Dados_Input');
writetable(resultsData, workbookName, 'Sheet', 'Resultados');

% Ajuste de uma reta input
coeficientes = polyfit(p, m, 1);
slope = coeficientes(1);
intercept = coeficientes(2);

% Ajuste de uma reta output
coeficientes1 = polyfit(p, me_wllspec, 1);
slope1 = coeficientes(1);
intercept1 = coeficientes(2);

% Calcula os valores previstos com base no ajuste
yFit = polyval(coeficientes, p);
yFit1 = polyval(coeficientes1, p);

% Calcula o coeficiente de determinação (R²)
R2 = 1 - sum((m - yFit).^2) / sum((m - mean(m)).^2);
R2_ = 1 - sum((me_wllspec - yFit1).^2) / sum((me_wllspec - mean(me_wllspec)).^2);

% Crie uma string com a equação da reta
equation = sprintf('y = %.2fx + %.2f', slope, intercept);
equation1 = sprintf('y = %.2fx + %.2f', slope1, intercept1);

% Printa o valor de A0 na tela
fprintf('O valor de A0 = %.12f\n', A0_wllspec);

% Printa o valor de A0original na tela
fprintf('Valor de A0original: %.12f\n', A0original);

% Printa o valor de lambda na tela
fprintf('O valor de lambda = %.12f\n', lambda_wllspec);

% Printa o valor de lambda na tela
fprintf('O valor de lambdaoriginal = %.12f\n', lambdaoriginal);

% Printa o valor de C na tela
fprintf('O valor de C = %.12f\n', C_wllspec);

% Imprime a equação da reta e o coeficiente de determinação
fprintf('Equação da reta input: %s\n', equation);
fprintf('Coeficiente de Determinação input (R²): %.4f\n', R2);
fprintf('Equação da reta output: %s\n', equation1);
fprintf('Coeficiente de Determinação output (R²): %.4f\n', R2_);

%Plota os valores de pressão e carga utilizados como input
figure(1)
subplot(2,1,1)
h = plot(p, m, 'x', p, yFit);
grid
title('Relação massa em função da pressão - input')
xlabel('Pressão (MPa)')
ylabel('Massa (Kg)')
legend(h, 'Curva Ajustada', 'Curva Original', 'Location', 'best');

% Ajustes do Texto
text(10, 330, equation, 'VerticalAlignment','bottom') 
text(10, 315, sprintf('R² = %.4f', R2), 'VerticalAlignment','top') 

%Plota os valores de pressão e carga utilizados como output
subplot(2,1,2)
i = plot(p, me_wllspec,'x', p, yFit1);
grid
title('Relação massa em função da pressão - output')
xlabel('Pressão (MPa)')
ylabel('Massa (Kg)')
legend(i, 'Curva Ajustada', 'Curva Original', 'Location', 'best');

% Ajustes do Texto
text(10, 330, equation, 'VerticalAlignment','bottom') 
text(10, 315, sprintf('R² = %.4f', R2_), 'VerticalAlignment','top') 
