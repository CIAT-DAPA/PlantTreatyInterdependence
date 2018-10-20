import time
import csv
import os
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup
from tqdm import tqdm

### PARAMETROS

userAgent = 'UOCBot/0.1: Mansfeld Web Scrapper'
url_base = "http://mansfeld.ipk-gatersleben.de/apex/"
url_start = "http://mansfeld.ipk-gatersleben.de/apex/f?p=185:8:"
url_post = "http://mansfeld.ipk-gatersleben.de/apex/wwv_flow.accept"
usesCSV = "mansfeld.uses.csv"
speciesCSV = "mansfeld.species.csv"
separator = '\t'


def cleanValue(value):
    value = value.replace("\n", "")
    value = value.replace("\r", "")
    value = value.replace(separator, " ")

    return value


def getUses():
    url = url_start

    dict = {}
    s = requests.Session()
    s.headers = {"User-Agent": userAgent}
    res = s.get(url)
    soup = BeautifulSoup(res.text, "lxml")
    options = soup.find_all("option")

    with open(usesCSV, 'w', encoding="utf-8") as file:
        for option in options:
            use = option.text
            use = cleanValue(use)
            id = str(option['value'])
            dict.update({id: use})
            file.writelines(id + separator + use + '\n')

    file.close()
    return dict


def getSpecies(desc, uses):
    # crear la lista de taxones
    url = url_start

    progress_bar = tqdm(total=uses.__len__(), desc=desc)

    ### INICIAR LA NAVEGACIÓN

    with open(speciesCSV, 'w', encoding="utf-8") as file:

        for key, value in uses.items():

            s = requests.Session()
            s.headers = {"User-Agent": userAgent}
            res = s.get(url)
            soup = BeautifulSoup(res.text, "lxml")

            use = value

            arg_names = []
            for name in soup.select("[name='p_arg_names']"):
                arg_names.append(name['value'])

            # prepare values
            salt = soup.select_one("[id='pSalt']")['value']
            protected = soup.select_one("[id='pPageItemsProtected']")['value']
            p_json = str(
                '{"salt": "' + salt + '","pageItems":{"itemsToSubmit":[{"n":"P8_NUTZID","v":["' + str(
                    key) + '"]},{"n":"P8_TXTSEARCH","v":""}],"protected":"' + protected + '","rowVersion":""}}')

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

            response = s.post(url_post, data=values)

            soup2 = BeautifulSoup(response.text, "html.parser")
            rows = soup2.findAll('a', href=True)

            flag = False;
            for row in rows:
                if flag:
                    if row.text != "":
                        taxon = row.text
                        url3 = urljoin(url_base, row['href'])
                        response3 = s.post(url3)
                        soup3 = BeautifulSoup(response3.text, "html.parser")
                        trs = soup3.findAll("tr")
                        name = ""
                        for tr in trs:
                            if name == "" and '::NO::sprachlink:E.' in str(tr):
                                tds = tr.findAll('td')
                                name = tds[1].text

                        taxon = cleanValue(taxon)
                        use = cleanValue(use)
                        name = cleanValue(name)
                        file.writelines(use + separator + taxon + separator + name + '\n')
                if row.text == "Contact":
                    flag = True

            file.flush()
            # update progress bar
            progress_bar.update(1)
            # adding delay
            time.sleep(0.5)

    file.close()
    # close progress bar
    progress_bar.close()



def writeItemCSV(filename, items):
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
        w = csv.DictWriter(csvFile, fieldnames=items.keys(), delimiter=fieldSeparator, quoting=csv.QUOTE_ALL)
        w.writeheader()
        w.writerow(items)


##################################################################


uses = getUses()
species = getSpecies(desc=speciesCSV, uses=uses)

##################################################################
