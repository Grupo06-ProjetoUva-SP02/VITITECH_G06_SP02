var database = require("../database/config");

function incidenciaMaiorMenor() {
    console.log("ACESSEI O AVISO  MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listar()");
    var instrucaoSql = `
    SELECT 
        CASE WEEKDAY(data_horario)
            WHEN 0 THEN 'Segunda-feira'
            WHEN 1 THEN 'Terça-feira'
            WHEN 2 THEN 'Quarta-feira'
            WHEN 3 THEN 'Quinta-feira'
            WHEN 4 THEN 'Sexta-feira'
            WHEN 5 THEN 'Sábado'
            WHEN 6 THEN 'Domingo'
        END AS dia_semana,
        MIN(umidade) AS umidade_minima,
        MAX(umidade) AS umidade_maxima
    FROM medida
    WHERE data_horario >= CURDATE() - INTERVAL 7 DAY
    GROUP BY WEEKDAY(data_horario), dia_semana
    ORDER BY WEEKDAY(data_horario);
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function KpiAlerta(idEmpresaVincular) {
    console.log("ACESSEI O AVISO  MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listar()");

    var instrucaoSql = `
    SELECT 
    *
    FROM vw_kpi_alerta
    WHERE idEmpresa = ${idEmpresaVincular}
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    incidenciaMaiorMenor,
    KpiAlerta
}
