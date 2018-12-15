(async function() {
    const functions = require("./src/functions.js");

    require("console.table");

    const readline = require("readline");
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    var res;
    var questionString = `Vad vill du göra? (skriv "menu" för tillgängliga kommandon)`;
    var menuString = `
    kommandon tillgängliga:
    log                         - visa loggen över kontoförändringar
    sum                         - visa summan av alla kontonummer
    secret                      - visa mitt hemliga konto
    interest acc <account>      - visa ränta för konto
    interest day <YYYY-MM-DD>   - visa ränta för en dag
    interest year <year>        - visa ränta för ett år`;
    var account;
    var day;
    var year;

    rl.setPrompt(questionString);
    rl.prompt();
    rl.on("close", exitProgram);
    rl.on("line", async (line) => {
        line = line.trim();
        line = line.toString();

        if (line.includes("interest")) {
            if (line.includes("acc")) {
                account = line.split(" ");
                line = "interest acc";
                account = account[2];
            } else if (line.includes("day")) {
                day = line.split(" ");
                line = "interest day";
                day = day[2];
            } else if (line.includes("year")) {
                year = line.split(" ");
                line = "interest year";
                year = year[2];
            }
        }

        switch (line) {
            case "menu":
                console.log(menuString);
                break;
            case "quit":
            case "exit":
                exitProgram(0);
                break;
            case "log":
                res = await functions.showLog();
                console.log("\n\n");
                console.table(res);
                break;
            case "sum":
                res = await functions.showBalanceSum();
                console.log("\n\n");
                console.table(res);
                break;
            case "secret":
                res = await functions.showSecretAccount();
                console.log("\n\n");
                console.table(res);
                break;
            case "interest acc":
                res = await functions.showAccountInterest(account);
                console.log("\n\n");
                console.table(res);
                break;
            case "interest day":
                res = await functions.showAccumulatedInterestDay(day);
                console.log("\n\n");
                console.table(res);
                break;
            case "interest year":
                res = await functions.showAccumulatedInterestYear(year);
                console.log("\n\n");
                console.table(res);
                break;
        }
        rl.prompt();
    });
})();

function exitProgram(code) {
    code = code || 0;

    console.info("Exiting");
    process.exit(code);
}
