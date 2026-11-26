var dashboardModel = require("../models/dashboardModel");


function incidenciaMaiorMenor(req, res) {
    dashboardModel.incidenciaMaiorMenor()
        .then((result) => {
            res.json(result)
        })
}

function KpiAlerta(req, res) {
    var idEmpresaVincular = req.params.idEmpresaVincular;

    console.log(idEmpresaVincular);

    if (idEmpresaVincular == undefined) {

        return res.status(400).send("idEmpresaVincular está undefined!");
    } else {

        dashboardModel.KpiAlerta(idEmpresaVincular)
            .then(
                function (resultado) {
                    res.json(resultado);
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log(
                        "\nHouve um erro ao tentar enviar os dados para a KPI_ALERTA! Erro: ",
                        erro.sqlMessage
                    );
                    res.status(500).json(erro.sqlMessage);
                }
            );

    }

}

module.exports = {
    incidenciaMaiorMenor,
    KpiAlerta
};
