var database = require("../database/config");

// Gráfico de Barras: Máxima e Mínima por dia da semana (últimos 7 dias)
function buscarUltimasMedidas(idBaia) {
    var instrucaoSql = `
        SELECT 
            CASE WEEKDAY(m.data_horario)
                WHEN 0 THEN 'Segunda-feira'
                WHEN 1 THEN 'Terça-feira'
                WHEN 2 THEN 'Quarta-feira'
                WHEN 3 THEN 'Quinta-feira'
                WHEN 4 THEN 'Sexta-feira'
                WHEN 5 THEN 'Sábado'
                WHEN 6 THEN 'Domingo'
            END AS dia_semana,
            MIN(m.umidade) AS umidade_minima,
            MAX(m.umidade) AS umidade_maxima
        FROM medida m
        JOIN sensor s ON m.fk_sensor = s.idSensor
        WHERE s.fk_baia = ${idBaia}
          AND m.data_horario >= CURDATE() - INTERVAL 7 DAY
        GROUP BY WEEKDAY(m.data_horario), dia_semana
        ORDER BY WEEKDAY(m.data_horario);
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

// Gráfico de Linha: Umidade em Tempo Real
function buscarMedidasEmTempoReal(idBaia) {
    var instrucaoSql = `
        SELECT 
            m.umidade AS umidade,
            DATE_FORMAT(m.data_horario, '%H:%i:%s') AS momento_grafico
        FROM medida m
        JOIN sensor s ON m.fk_sensor = s.idSensor
        WHERE s.fk_baia = ${idBaia}
        ORDER BY m.data_horario DESC
        LIMIT 10;
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal
};