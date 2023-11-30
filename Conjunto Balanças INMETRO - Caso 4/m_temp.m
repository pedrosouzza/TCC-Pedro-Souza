function m_vec = m_temp(p, t, A0original, lambdaoriginal, C, alpha, g)

    % Função Pmass:
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

    % Tamanho do vetor temperatura
    num_temp = length(t);

    % Inicializa o vetor de cargas aplicadas
    m_vec = zeros(size(p, 1), num_temp);

    %   Cargas aplicadas computadas do rearranjo da equação de pressão:
    for i = 1:num_temp

        m = (A0original/g)*(p.*(1 + lambdaoriginal*p).*(1 + alpha*(t(i) - 20))) - C;

        % Armazena os resultados nos vetores
        m_vec(:, i) = m;
    end
end
