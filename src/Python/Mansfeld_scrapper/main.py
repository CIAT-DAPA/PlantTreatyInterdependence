import os
import csv
from tqdm import tqdm
from bs4 import BeautifulSoup
import requests

### PARAMETROS

userAgent = 'UOCBot/0.1: Mansfel scrapper'



def getSpecies(desc, url):
    # crear la lista de convocatorias
    taxa = []

    last = 144
    progress_bar = tqdm(total=last, desc=desc)

    ### INICIAR LA NAVEGACIÖN

    for number in range(1, last + 1):

        s = requests.Session()
        s.headers = {"User-Agent": userAgent}
        res = s.get(url)
        soup = BeautifulSoup(res.text, "lxml")
        options = soup.find_all("option")

        use = ""
        for option in options:
            if str('"'+str(number)+'"') in str(option):
             use = option.text

        arg_names = []
        for name in soup.select("[name='p_arg_names']"):
            arg_names.append(name['value'])

        salt = soup.select_one("[id='pSalt']")['value']
        protected = soup.select_one("[id='pPageItemsProtected']")['value']

        p_json = str(
            '{"salt": "' + salt + '","pageItems":{"itemsToSubmit":[{"n":"P8_NUTZID","v":["'+str(number)+'"]},{"n":"P8_TXTSEARCH","v":""}],"protected":"' + protected + '","rowVersion":""}}')

        values = {
            'p_flow_id': soup.select_one("[name='p_flow_id']")['value'],
            'p_flow_step_id': soup.select_one("[name='p_flow_step_id']")['value'],
            'p_instance': soup.select_one("[name='p_instance']")['value'],
            'p_page_submission_id': soup.select_one("[name='p_page_submission_id']")['value'],
            'p_request': "Go",
            'p_reload_on_submit': "A",
            'p_json': p_json
        }

        s.headers.update({'Referer': url})
        response = s.post("http://mansfeld.ipk-gatersleben.de/apex/wwv_flow.accept", data=values)

        soup2 = BeautifulSoup(response.text, "html.parser")
        rows = soup2.findAll("a")


        flag = False;
        for row in rows:
            if flag:
                if row.text != "":
                    dict = {}
                    dict.update({"taxon": row.text})
                    dict.update({"use": use})
                    taxa.append(dict)
            if row.text == "Contact":
                flag=True


        # actualizar la barra de progreso
        progress_bar.update(1)
        # añadiendo delay
        # time.sleep(0.1)

        # cerrar barra de progreso
    progress_bar.close()
    return taxa


def writeCSV(filename, callsList):
    # PARAMETROS ESCRITURA DEL ARCHIVO DE SALIDA
    # directorio actual donde se va a ubicar el archivo
    currentDir = os.path.dirname(__file__)
    # ruta completa del archivo
    filePath = os.path.join(currentDir, filename)
    # separador de columnas
    fieldSeparator = ','

    ### ESCRIBIR ARCHIVO DE SALIDA

    # escribir archivo de salida
    with open(filePath, 'w', newline='', encoding='utf-8') as csvFile:
        terms_dict = {}
        terms_dict["use"] = "use"
        terms_dict["taxon"] = "taxon"
        # se usa un escritor de diccionarios
        writer = csv.DictWriter(csvFile, delimiter=fieldSeparator, fieldnames=terms_dict, quoting=csv.QUOTE_ALL)

        # escribir cabecera personalizada
        writer.writerow(terms_dict)

        # escribir valores por cada beca
        for call in callsList:
            writer.writerow(call)


##################################################################

# URL de la página del ICETEX a consultar las becas

fileCSV1 = "species.csv"
url1 = "http://mansfeld.ipk-gatersleben.de/apex/f?p=185:8:"
callsList1 = getSpecies(desc=fileCSV1, url=url1)
writeCSV(fileCSV1, callsList1)

##################################################################
