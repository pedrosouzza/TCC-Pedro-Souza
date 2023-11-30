% TESTE PROGRAMA MAIN_DPMETHOD0

% Chama a função pconst para obter os parâmetros
[A0s, lams, Cs, alps, A0t, A0original, lamt, Ct, alpt, g, p, t, ts, tt, tt_, alpha, C, lambdaoriginal, w] = pconst;

% Agora com os valores dos parâmetros, e pode usá-los para chamar a função mpmass
[ms,mt] = mpmass(p, g, A0t, A0s, lams, lamt, alps, alpt, ts, tt, Cs, Ct);

% Chama a função dpmethod0
[A0te_dpmethod0, lamte_dpmethod0, mte_dpmethod0] = Dpmethod0(p, tt_, mt, Ct, alpt, g);

% Cálculo do erro das massas da balança teste

for i = 1:n
    soma = vpa ((mte_dpmethod0(i) - mt(i))^2);
end

EM_dpmethod0 = vpa(1/n * sqrt(soma));

% Verifica se as variáveis dos erros são nulas e atribui o valor zero

if EM_dpmethod0 == 0
    EM_dpmethod0 = 0;
end

%--------------------------------------------------------------------------------------------------------------------------------

% Nome da pasta de trabalho no Excel
workbookName = 'Pressao_e_massa_input_dpmethod0.xlsx';

% Defina os dados que você deseja exportar
inputData = table(p', mte_dpmethod0', mt', 'VariableNames', {'Pressao (MPa)', 'Massa Balança Teste Estimada (Kg)', 'Massa Balança Teste Original (kg)'});
inputData_transposta = table(p, mte_dpmethod0, mt, 'VariableNames', {'Pressao (MPa)', 'Massa Balança Teste (Kg)', 'Massa Balança Teste Original (kg)'});
resultsData = table(A0te_dpmethod0, A0t, lamte_dpmethod0, lamt, EM_dpmethod0, 'VariableNames', {'Área Efetiva da Balança Teste Estimada (mm²)', 'Área Efetiva da Balança Teste Original (mm²)' 'Coef. Distorção da Balança Teste Estimado (1/MPa)', 'Coef. Distorção da Balança Teste Original (1/MPa)', 'Erro nas massas (Kg)'});

% Exporte os dados para a pasta de trabalho no Excel
writetable(inputData_transposta, workbookName, 'Sheet', 'Dados_Input');
writetable(resultsData, workbookName, 'Sheet', 'Resultados');

% Ajuste de uma reta para cada balança
coeficientes1 = polyfit(p, mt, 1);
slope = coeficientes1 (1);
intercept = coeficientes1 (2);

coeficientes2 = polyfit(p, ms, 1);
slope2 = coeficientes2 (1);
intercept2 = coeficientes2 (2);

coeficientes3 = polyfit(p, mte_dpmethod0, 1);
slope3 = coeficientes3 (1);
intercept3 = coeficientes3 (2);

% Calcula os valores previstos com base no ajuste
yFit = polyval(coeficientes1, p);
yFit2 = polyval(coeficientes2, p);
yFit3 = polyval(coeficientes3, p);

% Calcula o coeficiente de determinação (R²)
R2 = 1 - sum((mt - yFit).^2) / sum((mt - mean(mt)).^2);
R2_ = 1 - sum((ms - yFit).^2) / sum((ms - mean(ms)).^2);
R2__ = 1 - sum((mte_dpmethod0 - yFit3).^2) / sum((mte_dpmethod0 - mean(mte_dpmethod0)).^2);

% Crie uma string com a equação da reta
equation1 = sprintf('y = %.2fx + %.2f', slope, intercept);
equation2 = sprintf('y = %.2fx + %.2f', slope2, intercept2);
equation3 = sprintf('y = %.2fx + %.2f', slope3, intercept3);

% Printa o valor de A0 na tela
fprintf('O valor de A0 da Balança Teste = %.12f\n', A0te_dpmethod0);
fprintf('O valor de A0 original da Balança Teste = %.12f\n', A0t);

% Printa o valor de lambda na tela
fprintf('O valor de lambda da Balança Teste = %.12f\n', lamte_dpmethod0);
fprintf('O valor de lambda original da Balança Teste = %.12f\n', lamt);

% Imprime a equação da reta e o coeficiente de determinação
fprintf('Equação da reta da balança teste input: %s\n', equation1);
fprintf('Coeficiente de Determinação da balança teste input (R²): %.4f\n', R2);
fprintf('Equação da reta da balança padrão: %s\n', equation2);
fprintf('Coeficiente de Determinação balança padrão (R²): %.4f\n', R2_);
fprintf('Equação da reta da balança teste output: %s\n', equation3);
fprintf('Coeficiente de Determinação balança teste output (R²): %.4f\n', R2__);

%Plota os valores de pressão e carga utilizados como input
figure(1)
subplot(3,1,1)
h = plot(p, mt, 'x', p, yFit);
grid
title('Relação massa em função da pressão da balança teste')
xlabel('Pressão (MPa)')
ylabel('Massa (Kg)')
legend(h, 'Curva Ajustada', 'Curva Original', 'Location', 'best');

% Ajustes do Texto
text(10, 330, equation1, 'VerticalAlignment','bottom') 
text(10, 315, sprintf('R² = %.4f', R2), 'VerticalAlignment','top')

% Plota os valores de pressão e carga utilizados como output da balança teste

subplot(3,1,2)
i = plot(p, mte_dpmethod0, 'x', p, yFit3);
grid
title('Relação massa em função da pressão da balança teste output')
xlabel('Pressão (MPa)')
ylabel('Massa (Kg)')
legend(i, 'Curva Ajustada', 'Curva Original', 'Location', 'best');

% Ajustes do Texto
text(10, 330, equation1, 'VerticalAlignment','bottom') 
text(10, 315, sprintf('R² = %.4f', R2__), 'VerticalAlignment','top') 

% Plota os valores de pressão e carga utilizados como da balança padrão

subplot(3,1,3)
j = plot(p, mt, 'x', p, yFit2);
grid
title('Relação massa em função da pressão da balança padrão')
xlabel('Pressão (MPa)')
ylabel('Massa (Kg)')
legend(j, 'Curva Ajustada', 'Curva Original', 'Location', 'best');

% Ajustes do Texto
text(10, 330, equation2, 'VerticalAlignment','bottom') 
text(10, 315, sprintf('R² = %.4f', R2_), 'VerticalAlignment','top') 
