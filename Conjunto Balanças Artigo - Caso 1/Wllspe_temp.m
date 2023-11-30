function [A0_wllspe_vec, lambda_wllspe_vec, me_wllspe] = Wllspe_temp(p, t, m_vec, w, C, alpha, g)
    % Função WLLSPE modificada para aceitar m_vec e iterar sobre as colunas

    % Número de temperaturas
    num_temperaturas = length(t);

    % Inicializa vetores de parâmetros
    A0_wllspe_vec = zeros(num_temperaturas, 1);
    lambda_wllspe_vec = zeros(num_temperaturas, 1);
    me_wllspe = zeros(length(p) * num_temperaturas, 1);

    % Loop sobre cada temperatura
    for i = 1:num_temperaturas
        % Seleciona a coluna correspondente de m_vec
        m = m_vec(:, i);

        % Matriz de observação ponderada (depende dos dados exatos de p e t)
        wt = (1 + alpha * (t(i) - 20)) * w;
        A = [wt .* p, wt .* p .* p];

        % Vetor ponderado do lado direito (depende dos dados inexatos de m)
        y = w .* (m + C) .* g;

        % Resolve a equação linear e retira os valores nulos da matriz
        b = A \ y;

        % Extrai parâmetros da área efetiva
        A0_wllspe_vec(i) = b(1);
        lambda_wllspe_vec(i) = b(2) / b(1);

        % Calcula os valores de carga aplicada que são determinados pela equação
        % de pressão e por essas estimativas
        me_wllspe((i - 1) * length(p) + 1 : i * length(p)) = pmass(p, t(i), A0_wllspe_vec(i), lambda_wllspe_vec(i), C, alpha, g);
    end
end
