import time
import csv
import os
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup
from tqdm import tqdm

### PARAMETROS

userAgent = "UOCBot/0.1: UPOV PLUTO Web Scrapper"
url_start = "https://www3.wipo.int/authpage/signin.xhtml?goto=https%3A%2F%2Fwww3.wipo.int%3A443%2Fpluto%2Fuser%2Fen%2Findex.jsp"
url_post = "https://www3.wipo.int/authpage/signin.xhtml"
usesCSV = "pluto.uses.csv"
speciesCSV = "pluto.species.csv"
separator = '\t'
equals = "="
properties = {}


def cleanValue(value):
    value = value.replace("\n", "")
    value = value.replace("\r", "")
    value = value.replace(separator, " ")

    return value



def getSpecies(desc):
    # crear la lista de taxones
    url = url_start

    progress_bar = tqdm(total=1, desc=desc)

    ### INICIAR LA NAVEGACIÓN

    with open(speciesCSV, 'w', encoding="utf-8") as file:

        s = requests.Session()
        s.headers = {"User-Agent": userAgent}
        response1 = s.get(url)
        soup = BeautifulSoup(response1.text, "lxml")



        values = {
            'authform': 'authform',
            'authform_authStateId': soup.select_one("[name='authform_authStateId']")['value'],
            'authform_fields:0:authform_text': properties.get("user"),
            'authform_fields:1:authform_mask': properties.get("password"),
            'authform_signin': soup.select_one("[name='authform_signin']")['value'],
            'javax.faces.ViewState': soup.select_one("[name='javax.faces.ViewState']")['value']

        }


        s.headers.update({'Referer': url})

        response2 = s.post(url_post, data=values)

        soup2 = BeautifulSoup(response2.text, "html.parser")

        print(response2.text)


        rows = soup2.findAll('td', href=True)

        for row in rows:
            if row.text != "":
                taxon = row.text
                taxon = cleanValue(taxon)
                print(taxon)
                #file.writelines(  taxon + '\n')


        #file.flush()
        # update progress bar
        #progress_bar.update(1)
        # adding delay
        #time.sleep(0.5)

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



def loadCredentials(filename):

    with open(filename) as f:

        for line in f:
            if equals in line:

                name, value = line.split(equals, 1)

                properties[name.strip()] = value.strip()



##################################################################

loadCredentials('credentials.properties')

species = getSpecies(desc=speciesCSV)

##################################################################
