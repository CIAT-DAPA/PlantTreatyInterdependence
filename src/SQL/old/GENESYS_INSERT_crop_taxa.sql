
CREATE TABLE CIAT_crop_taxon (
  `crop` VARCHAR(45) NULL,
  `taxon` VARCHAR(45) NOT NULL,
  `rank` VARCHAR(45) NULL);
  
-- load crop and taxa relationship
INSERT INTO CIAT_crop_taxon(crop, taxon, rank)
values 
( 'Okra','Abelmoschus','genus'),
( 'Slippery cabbage','Abelmoschus','genus'),
( 'Devils cotton','Abroma','genus'),
( 'Velvet leaf','Abutilon','genus'),
( 'Feijoa','Acca','genus'),
( 'Maple sugar','Acer','genus'),
( 'Chicle','Achras','genus'),
( 'Kiwi fruit','Actinidia','genus'),
( 'Wheat','Aegilops','genus'),
( 'Aeschynomene','Aeschynomene','genus'),
( 'Agave','Agave','genus'),
( 'Sisal','Agave','genus'),
( 'Agropyron','Agropyron','genus'),
( 'Wheat','Agropyron','genus'),
( 'Agrostis','Agrostis','genus'),
( 'Candlenut','Aleurites','genus'),
( 'Tung nuts','Aleurites','genus'),
( 'Garlic','Allium','genus'),
( 'Leeks and other alliaceous vegetables','Allium','genus'),
( 'Onions','Allium','genus'),
( 'Alopecurus','Alopecurus','genus'),
( 'Alysicarpus','Alysicarpus','genus'),
( 'Amaranth','Amaranthus','genus'),
( 'Kiwicha','Amaranthus','genus'),
( 'Wheat','Amblyopyrum','genus'),
( 'Cardamoms','Amomum','genus'),
( 'Cashews','Anacardium','genus'),
( 'Pineapples','Ananas','genus'),
( 'Andropogon','Andropogon','genus'),
( 'Dill','Anethum','genus'),
( 'Cherimoya','Annona','genus'),
( 'Atemoya','Annona','genus'),
( 'Soursop','Annona','genus'),
( 'Sugar apple','Annona','genus'),
( 'Custard apple','Annona','genus'),
( 'Chervil','Anthriscus','genus'),
( 'Celery','Apium','genus'),
( 'Groundnuts','Arachis','genus'),
( 'Strawberry tree','Arbutus','genus'),
( 'Areca nuts','Areca','genus'),
( 'Horseradish','Armoracia','genus'),
( 'Arracacha','Arracacia','genus'),
( 'Arrhenatherum','Arrhenatherum','genus'),
( 'Tarragon','Artemisia','genus'),
( 'Breadfruit','Artocarpus','genus'),
( 'Jackfruit','Artocarpus','genus'),
( 'Pawpaw','Asimina','genus'),
( 'Asparagus','Asparagus','genus'),
( 'Astragalus','Astragalus','genus'),
( 'Chontadura','Astrocaryum','genus'),
( 'Atriplex','Atriplex','genus'),
( 'Orache','Atriplex','genus'),
( 'Orache','Atriplex','genus'),
( 'Oats','Avena','genus'),
( 'Carambola','Averrhoa','genus'),
( 'Bamboo shoot','Bambusa','genus'),
( 'Malabar spinach','Basella','genus'),
( 'Wax gourd','Benincasa','genus'),
( 'Brazil nut','Bertholletia','genus'),
( 'Beets','Beta','genus'),
( 'Sugar beets','Beta','genus'),
( 'Annato','Bixa','genus'),
( 'Ackee','Blighia','genus'),
( 'Ramie','Boehmeria','genus'),
( 'Brachiaria','Brachiaria','genus'),
( 'Cabbages','Brassica','genus'),
( 'Cabbages and other brassicas','Brassica','genus'),
( 'Canola','Brassica','genus'),
( 'Ethiopian rape','Brassica','genus'),
( 'Rapeseed and Mustards','Brassica','genus'),
( 'Turnips','Brassica','genus'),
( 'Pigeonpeas','Cajanus','genus'),
( 'Calopogonium','Calopogonium','genus'),
( 'Tea','Camellia','genus'),
( 'Pili nut','Canarium','genus'),
( 'Jack bean','Canavalia','genus'),
( 'Sword bean','Canavalia','genus'),
( 'Achira','Canna','genus'),
( 'Hemp','Cannabis','genus'),
( 'Capers','Capparis','genus'),
( 'Chillies and peppers','Capsicum','genus'),
( 'Carapa','Carapa','genus'),
( 'Papayas','Carica','genus'),
( 'Safflower','Carthamnus','genus'),
( 'Caraway','Carum','genus'),
( 'Pecan','Carya','genus'),
( 'Butter-nut','Caryocar','genus'),
( 'Chestnuts','Castanea','genus'),
( 'Kapok','Ceiba','genus'),
( 'Pearl millet','Cenchrus','genus'),
( 'Centrosema','Centrosema','genus'),
( 'Carobs','Ceratonia','genus'),
( 'Kaniwa','Chenopodium','genus'),
( 'Quinoa','Chenopodium','genus'),
( 'Pyrethrum','Chrysanthemum','genus'),
( 'Cainito','Chrysophyllum','genus'),
( 'Chickpeas','Cicer','genus'),
( 'Chicory','Cichorium','genus'),
( 'Cinnamon','Cinnamomum','genus'),
( 'Watermelons','Citrullus','genus'),
( 'Chinotto','Citrus','genus'),
( 'Citron','Citrus','genus'),
( 'Grapefruits','Citrus','genus'),
( 'Lemons and limes','Citrus','genus'),
( 'Mandarines','Citrus','genus'),
( 'Oranges','Citrus','genus'),
( 'Coconuts','Cocos','genus'),
( 'Coffee','Coffea','genus'),
( 'Adlay','Coix','genus'),
( 'Kola nuts','Cola','genus'),
( 'Taro','Colocasia','genus'),
( 'Jute','Corchorus','genus'),
( 'Coriander','Coriandrum','genus'),
( 'Coronilla','Coronilla','genus'),
( 'Hazelnuts','Corylus','genus'),
( 'Crambe','Crambe','genus'),
( 'Azarole','Crataegus','genus'),
( 'Saffron','Crocus','genus'),
( 'Sunn hemp','Crotalaria','genus'),
( 'Purging croton','Croton','genus'),
( 'Cucumbers and gherkins','Cucumis','genus'),
( 'Melons','Cucumis','genus'),
( 'West Indian Gherkin','Cucumis','genus'),
( 'Butternut squash','Cucurbita','genus'),
( 'Pumpkin','Cucurbita','genus'),
( 'Zucchini','Cucurbita','genus'),
( 'Cushaw','Cucurbita','genus'),
( 'Fig leaf gourd','Cucurbita','genus'),
( 'Cumin','Cuminum','genus'),
( 'Turmeric','Curcuma','genus'),
( 'Quinces','Cydonia','genus'),
( 'Citronella','Cymbopogon','genus'),
( 'Artichokes','Cynara','genus'),
( 'Chufa','Cyperus','genus'),
( 'Dactylis','Dactylis','genus'),
( 'Carrots','Daucus','genus'),
( 'Desmodium','Desmodium','genus'),
( 'Fonio','Digitaria','genus'),
( 'Longan','Dimocarpus','genus'),
( 'Yams','Dioscorea','genus'),
( 'Persimmons','Diospyros','genus'),
( 'Durian','Durio','genus'),
( 'Jelutong','Dyera','genus'),
( 'Japanese millet','Echinochloa','genus'),
( 'Oil palm','Elaeis','genus'),
( 'Finger millet','Eleusine','genus'),
( 'Cardamoms','Elletaria','genus'),
( 'Wheat','Elymus','genus'),
( 'Teff','Eragrostis','genus'),
( 'Loquat','Eriobotrya','genus'),
( 'Buckwheat','Fagopyrum','genus'),
( 'Beech nut','Fagus','genus'),
( 'Festuca','Festuca','genus'),
( 'Figs','Ficus','genus'),
( 'Fennel','Foeniculum','genus'),
( 'Grapefruits','Fortunella','genus'),
( 'Kumquat','Fortunella','genus'),
( 'Mandarines','Fortunella','genus'),
( 'Oranges','Fortunella','genus'),
( 'Strawberries','Fragaria','genus'),
( 'Fique','Furcraea','genus'),
( 'Giant cabuya','Furcraea','genus'),
( 'Galactia','Galactia','genus'),
( 'Mangosteen','Garcinia','genus'),
( 'Huckleberry','Gaylussacia','genus'),
( 'Soybeans','Glycine','genus'),
( 'Licorice','Glycyrrhiza','genus'),
( 'Cotton','Gossypium','genus'),
( 'Noog','Guizotia','genus'),
( 'Spider plant','Gynandropsis','genus'),
( 'Hedysarum','Hedysarum','genus'),
( 'Jerusalem artichoke','Helianthus','genus'),
( 'Sunflowers','Helianthus','genus'),
( 'Rubber, natural','Hevea','genus'),
( 'Kenaf','Hibiscus','genus'),
( 'Roselle','Hibiscus','genus'),
( 'Barley','Hordeum','genus'),
( 'Hops','Humulus','genus'),
( 'Mate','Ilex','genus'),
( 'Badian','Illicium','genus'),
( 'Indigofera','Indigofera','genus'),
( 'Sweetpotatoes','Ipomoea','genus'),
( 'Physic nut','Jatropha','genus'),
( 'Walnuts','Juglans','genus'),
( 'Lablab','Lablab','genus'),
( 'Lettuce','Lactuca','genus'),
( 'Calabash','Lagenaria','genus'),
( 'Grasspea','Lathyrus','genus'),
( 'Bay leaf','Laurus','genus'),
( 'Lavender','Lavandula','genus'),
( 'Lentils','Lens','genus'),
( 'Cress','Lepidium','genus'),
( 'Maca','Lepidium','genus'),
( 'Lespedeza','Lespedeza','genus'),
( 'Leucaena','Leucaena','genus'),
( 'Wheat','Leymus','genus'),
( 'Oiticica','Licania','genus'),
( 'Flax','Linum','genus'),
( 'Litchi','Litchi','genus'),
( 'Lolium','Lolium','genus'),
( 'Lotus','Lotus','genus'),
( 'Lupins','Lupinus','genus'),
( 'Albardine','Lygeum','genus'),
( 'Macadamia nut','Macadamia','genus'),
( 'Macroptilium','Macroptilium','genus'),
( 'Mahuwa','Madhuca','genus'),
( 'Apple','Malus','genus'),
( 'Mammee','Mammea','genus'),
( 'Mango','Mangifera','genus'),
( 'Cassava','Manihot','genus'),
( 'Ceara','Manihot','genus'),
( 'Sapodilla','Manilkara','genus'),
( 'Arrowroot','Maranta','genus'),
( 'Alfalfa','Medicago','genus'),
( 'Melilotus','Melilotus','genus'),
( 'Peppermint','Mentha','genus'),
( 'Medlar','Mespilus','genus'),
( 'Sago palm','Metroxylon','genus'),
( 'Mauka','Mirabilis','genus'),
( 'Mulberry','Morus','genus'),
( 'Velvet bean','Mucuna','genus'),
( 'Abaca','Musa','genus'),
( 'Bananas','Musa','genus'),
( 'Plantains','Musa','genus'),
( 'Nutmeg','Myristica','genus'),
( 'Myrtle','Myrtus','genus'),
( 'Watercress','Nasturtium','genus'),
( 'Caroa','Neoglaziovia','genus'),
( 'Neonotonia','Neonotonia','genus'),
( 'Rambutan','Nephelium','genus'),
( 'Tobacco','Nicotiana','genus'),
( 'Basil','Ocimum','genus'),
( 'Water dropwort','Oenanthe','genus'),
( 'Olives','Olea','genus'),
( 'Onobrychis','Onobrychis','genus'),
( 'Prickly pear','Opuntia','genus'),
( 'Marjoram','Origanum','genus'),
( 'Oregano','Origanum','genus'),
( 'Ornithopus','Ornithopus','genus'),
( 'African rice','Oryza','genus'),
( 'Asian rice','Oryza','genus'),
( 'Oca','Oxalis','genus'),
( 'Jicama','Pachyrhizus','genus'),
( 'Ahipa','Pachyrhizus','genus'),
( 'Gutta-percha','Palaquium','genus'),
( 'Proso millet','Panicum','genus'),
( 'Poppies','Papaver','genus'),
( 'Guayule','Parthenium','genus'),
( 'Kodo millet','Paspalum','genus'),
( 'Passionfruit','Passiflora','genus'),
( 'Parsnip','Pastinaca','genus'),
( 'Pearl millet','Pennisetum','genus'),
( 'Perilla','Perilla','genus'),
( 'Avocado','Persea','genus'),
( 'Parsley','Petroselinum','genus'),
( 'Canary seed','Phalaris','genus'),
( 'Phalaris','Phalaris','genus'),
( 'Common bean','Phaseolus','genus'),
( 'Lima bean','Phaseolus','genus'),
( 'Runner bean','Phaseolus','genus'),
( 'Tepary bean','Phaseolus','genus'),
( 'Year bean','Phaseolus','genus'),
( 'Phleum','Phleum','genus'),
( 'Dates','Phoenix','genus'),
( 'New Zealand flax','Phormium','genus'),
( 'Bamboo shoot','Phyllostachys','genus'),
( 'Tomatillo','Physalis','genus'),
( 'Allspice','Pimenta','genus'),
( 'Anise','Pimpinella','genus'),
( 'Pine nut','Pinus','genus'),
( 'Pepper','Piper','genus'),
( 'Pistachios','Pistacia','genus'),
( 'Peas','Pisum','genus'),
( 'Poa','Poa','genus'),
( 'Grapefruits','Poncirus','genus'),
( 'Mandarines','Poncirus','genus'),
( 'Oranges','Poncirus','genus'),
( 'Pongamia oil','Pongamia','genus'),
( 'Mamey sapote','Pouteria','genus'),
( 'Prosopis','Prosopis','genus'),
( 'Almonds','Prunus','genus'),
( 'Apricot','Prunus','genus'),
( 'Cherries','Prunus','genus'),
( 'Peaches and nectarines','Prunus','genus'),
( 'Plums','Prunus','genus'),
( 'Guavas','Psidium','genus'),
( 'Winged bean','Psophocarpus','genus'),
( 'Pueraria','Pueraria','genus'),
( 'Pomegranate','Punica','genus'),
( 'Pears','Pyrus','genus'),
( 'Radish','Raphanus','genus'),
( 'Rhubarb','Rheum','genus'),
( 'Rhynchosia','Rhynchosia','genus'),
( 'Currants','Ribes','genus'),
( 'Gooseberries','Ribes','genus'),
( 'Castor bean','Ricinus','genus'),
( 'Rosemary','Rosmarinus','genus'),
( 'Raspberries','Rubus','genus'),
( 'Sorrel','Rumex','genus'),
( 'Sugarcane','Saccharum','genus'),
( 'Salsola','Salsola','genus'),
( 'Elderberry','Sambucus','genus'),
( 'Carneros Yucca','Samuela','genus'),
( 'Snake plant','Sansevieria','genus'),
( 'Tallowtree','Sapium','genus'),
( 'Savory','Satureja','genus'),
( 'Black salsify','Scorzonera','genus'),
( 'Rye','Secale','genus'),
( 'Wheat','Secale','genus'),
( 'Chayote','Sechium','genus'),
( 'Sesame','Sesamum','genus'),
( 'Sesbania','Sesbania','genus'),
( 'Foxtail millet','Setaria','genus'),
( 'Shala tree','Shorea','genus'),
( 'Tallowtree','Shorea','genus'),
( 'Jojoba','Simmonsia','genus'),
( 'Yacon','Smallanthus','genus'),
( 'Eggplant','Solanum','genus'),
( 'Naranjilla','Solanum','genus'),
( 'Potatoes','Solanum','genus'),
( 'Tomatoes','Solanum','genus'),
( 'Pepino','Solanum','genus'),
( 'Tree tomato','Solanum','genus'),
( 'African eggplant','Solanum','genus'),
( 'Black nightshade','Solanum','genus'),
( 'Service tree','Sorbus','genus'),
( 'Sorghum','Sorghum','genus'),
( 'Spinach','Spinacia','genus'),
( 'Mombin','Spondias','genus'),
( 'Tallowtree','Stillingia','genus'),
( 'Esparto','Stipa','genus'),
( 'Stylosanthes','Stylosanthes','genus'),
( 'Cloves','Syzygium','genus'),
( 'Ceylon-spinach','Talinum','genus'),
( 'Tamarind','Tamarindus','genus'),
( 'New Zealand spinach','Tetragonia','genus'),
( 'Cocoa','Theobroma','genus'),
( 'Wheat','Thinopyrum','genus'),
( 'Thyme','Thymus','genus'),
( 'Salsify','Tragopogon','genus'),
( 'Tallowtree','Triadica','genus'),
( 'Snake gourd','Trichosanthes','genus'),
( 'Clovers','Trifolium','genus'),
( 'Fenugreek','Trigonella','genus'),
( 'Maize','Tripsacum','genus'),
( 'Tripsacum','Tripsacum','genus'),
( 'Triticale','Triticosecale','genus'),
( 'Wheat','Triticum','genus'),
( 'Mashua','Tropaeolum','genus'),
( 'Ulluco','Ullucus','genus'),
( 'Caesarweed','Urena','genus'),
( 'Brachiaria','Urochloa','genus'),
( 'Blueberry','Vaccinium','genus'),
( 'Cranberries','Vaccinium','genus'),
( 'Vanilla','Vanilla','genus'),
( 'Babaco','Vasconcellea','genus'),
( 'Tung nuts','Vernicia','genus'),
( 'Faba beans','Vicia','genus'),
( 'Vetch','Vicia','genus'),
( 'Adzuki bean','Vigna','genus'),
( 'Bambara bean','Vigna','genus'),
( 'Black gram','Vigna','genus'),
( 'Cowpeas','Vigna','genus'),
( 'Mat bean','Vigna','genus'),
( 'Mung bean','Vigna','genus'),
( 'Rice bean','Vigna','genus'),
( 'Karite nuts','Vitellaria','genus'),
( 'Grapes','Vitis','genus'),
( 'Yautia, cocoyam','Xanthosoma','genus'),
( 'Triticale','xTriticosecale','genus'),
( 'Carneros Yucca','Yucca','genus'),
( 'Maize','Zea','genus'),
( 'Ginger','Zingiber','genus'),
( 'Wildrice','Zizania','genus'),
( 'Jujube','Zizyphus','genus'),
( 'Zornia','Zornia','genus');

-- load crop and taxa relationship
INSERT INTO genesys_2018.CIAT_crop_taxon(crop, taxon, rank)
values ( 'Okra','Abelmoschus esculentus','taxonName'),
( 'Slippery cabbage','Abelmoschus manihot','taxonName'),
( 'Devils cotton','Abroma augustum','taxonName'),
( 'Velvet leaf','Abutilon theophrasti','taxonName'),
( 'Feijoa','Acca sellowiana','taxonName'),
( 'Maple sugar','Acer saccharum','taxonName'),
( 'Chicle','Achras zapota','taxonName'),
( 'Kiwi fruit','Actinidea deliciosa','taxonName'),
( 'Kiwi fruit','Actinidia arguta','taxonName'),
( 'Kiwi fruit','Actinidia chinensis','taxonName'),
( 'Aeschynomene','Aeschynomene americana','taxonName'),
( 'Agave','Agave americana','taxonName'),
( 'Agave','Agave cantala','taxonName'),
( 'Agave','Agave foetida','taxonName'),
( 'Agave','Agave fourcroydes','taxonName'),
( 'Agave','Agave lecheguilla','taxonName'),
( 'Agave','Agave letonae','taxonName'),
( 'Sisal','Agave sisalana','taxonName'),
( 'Agropyron','Agropyron cristatum','taxonName'),
( 'Agropyron','Agropyron desertorum','taxonName'),
( 'Agrostis','Agrostis stolonifera','taxonName'),
( 'Agrostis','Agrostis tenuis','taxonName'),
( 'Tung nuts','Aleurites fordii','taxonName'),
( 'Tung nuts','Aleurites fordii','taxonName'),
( 'Candlenut','Aleurites moluccanus','taxonName'),
( 'Onions','Allium cepa','taxonName'),
( 'Leeks and other alliaceous vegetables','Allium porrum','taxonName'),
( 'Garlic','Allium sativum','taxonName'),
( 'Leeks and other alliaceous vegetables','Allium schoenoprasum','taxonName'),
( 'Alopecurus','Alopecurus pratensis','taxonName'),
( 'Alysicarpus','Alysicarpus rugosus','taxonName'),
( 'Alysicarpus','Alysicarpus vaginalis','taxonName'),
( 'Amaranth','Amaranthus blitum','taxonName'),
( 'Kiwicha','Amaranthus caudatus','taxonName'),
( 'Amaranth','Amaranthus cruentus','taxonName'),
( 'Amaranth','Amaranthus cruentus','taxonName'),
( 'Amaranth','Amaranthus dubius','taxonName'),
( 'Amaranth','Amaranthus hypochondriacus','taxonName'),
( 'Amaranth','Amaranthus tricolor','taxonName'),
( 'Cardamoms','Amomum subulatum','taxonName'),
( 'Cashews','Anacardium occidentale','taxonName'),
( 'Pineapples','Ananas comosus','taxonName'),
( 'Andropogon','Andropogon gayanus','taxonName'),
( 'Dill','Anethum graveolens','taxonName'),
( 'Cherimoya','Annona cherimola','taxonName'),
( 'Soursop','Annona muricata','taxonName'),
( 'Custard apple','Annona reticulata','taxonName'),
( 'Sugar apple','Annona squamosa','taxonName'),
( 'Atemoya','Annona xcherimola','taxonName'),
( 'Chervil','Anthriscus cerefolium','taxonName'),
( 'Celery','Apium graveolens','taxonName'),
( 'Groundnuts','Arachis hypogaea','taxonName'),
( 'Strawberry tree','Arbutus unedo','taxonName'),
( 'Areca nuts','Areca catechu','taxonName'),
( 'Horseradish','Armoracia rusticana','taxonName'),
( 'Arracacha','Arracacoa xanthorrhiza','taxonName'),
( 'Arrhenatherum','Arrhenatherum elatius','taxonName'),
( 'Tarragon','Artemisia dracunculus','taxonName'),
( 'Breadfruit','Artocarpus altilis','taxonName'),
( 'Jackfruit','Artocarpus heterophyllus','taxonName'),
( 'Pawpaw','Asimina triloba','taxonName'),
( 'Asparagus','Asparagus officinalis','taxonName'),
( 'Astragalus','Astragalus arenarius','taxonName'),
( 'Astragalus','Astragalus chinensis','taxonName'),
( 'Astragalus','Astragalus cicer','taxonName'),
( 'Chontadura','Astrocaryum standleyanum','taxonName'),
( 'Atriplex','Atriplex halimus','taxonName'),
( 'Orache','Atriplex hortensis','taxonName'),
( 'Atriplex','Atriplex nummularia','taxonName'),
( 'Orache','Atriplex patula','taxonName'),
( 'Oats','Avena sativa','taxonName'),
( 'Carambola','Averrhoa carambola','taxonName'),
( 'Bamboo shoot','Bambusa vulgaris','taxonName'),
( 'Malabar spinach','Basella alba','taxonName'),
( 'Malabar spinach','Basella rubra','taxonName'),
( 'Wax gourd','Benincasa hispida','taxonName'),
( 'Brazil nut','Bertholletia excelsa','taxonName'),
( 'Beets','Beta vulgaris','taxonName'),
( 'Sugar beets','Beta vulgaris','taxonName'),
( 'Annato','Bixa orellana','taxonName'),
( 'Ackee','Blighia sapida','taxonName'),
( 'Ramie','Boehmeria nivea','taxonName'),
( 'Brachiaria','Brachiaria brizantha','taxonName'),
( 'Brachiaria','Brachiaria humidicola','taxonName'),
( 'Brachiaria','Brachiaria ruziziensis','taxonName'),
( 'Rapeseed and mustards','Brassica alba','taxonName'),
( 'Cabbages and other brassicas','Brassica carinata','taxonName'),
( 'Ethiopian rape','Brassica carinata','taxonName'),
( 'Cabbages and other brassicas','Brassica juncea','taxonName'),
( 'Canola','Brassica juncea','taxonName'),
( 'Cabbages and other brassicas','Brassica napus','taxonName'),
( 'Rapeseed and Mustards','Brassica napus','taxonName'),
( 'Rapeseed and mustards','Brassica nigra','taxonName'),
( 'Cabbages','Brassica oleracea','taxonName'),
( 'Cabbages and other brassicas','Brassica oleracea','taxonName'),
( 'Cabbages and other brassicas','Brassica rapa','taxonName'),
( 'Rapeseed and Mustards','Brassica rapa','taxonName'),
( 'Turnips','Brassica rapa','taxonName'),
( 'Pigeonpeas','Cajanus cajan','taxonName'),
( 'Calopogonium','Calopogonium caeruleum','taxonName'),
( 'Calopogonium','Calopogonium mucunoides','taxonName'),
( 'Tea','Camellia sinensis','taxonName'),
( 'Pili nut','Canarium harveyi','taxonName'),
( 'Pili nut','Canarium indicum','taxonName'),
( 'Pili nut','Canarium ovatum','taxonName'),
( 'Jack bean','Canavalia ensiformis','taxonName'),
( 'Sword bean','Canavalia gladiata','taxonName'),
( 'Achira','Canna edulis','taxonName'),
( 'Hemp','Cannabis sativa','taxonName'),
( 'Capers','Capparis spinosa','taxonName'),
( 'Chillies and peppers','Capsicum annuum','taxonName'),
( 'Chillies and peppers','Capsicum baccatum','taxonName'),
( 'Chillies and peppers','Capsicum chinense','taxonName'),
( 'Chillies and peppers','Capsicum frutescens','taxonName'),
( 'Chillies and peppers','Capsicum pubescens','taxonName'),
( 'Carapa','Carapa guianensis','taxonName'),
( 'Papayas','Carica papaya','taxonName'),
( 'Babaco','Carica pentagona','taxonName'),
( 'Safflower','Carthamus tinctorius','taxonName'),
( 'Caraway','Carum carvi','taxonName'),
( 'Pecan','Carya illinoinensis','taxonName'),
( 'Butter-nut','Caryocar nuciferum','taxonName'),
( 'Chestnuts','Castanea sativa','taxonName'),
( 'Kapok','Ceiba pentandra','taxonName'),
( 'Pearl millet','Cenchrus americanus','taxonName'),
( 'Centrosema','Centrosema pubescens','taxonName'),
( 'Carobs','Ceratonia siliqua','taxonName'),
( 'Kaniwa','Chenopodium pallidicaule','taxonName'),
( 'Quinoa','Chenopodium quinoa','taxonName'),
( 'Pyrethrum','Chrysanthemum cinerariifolium','taxonName'),
( 'Cainito','Chrysophyllum cainito','taxonName'),
( 'Chickpeas','Cicer arietinum','taxonName'),
( 'Chicory','Cichorium endivia','taxonName'),
( 'Chicory','Cichorium intybus','taxonName'),
( 'Cinnamon','Cinnamomum cassia','taxonName'),
( 'Cinnamon','Cinnamomum verum','taxonName'),
( 'Watermelons','Citrullus lanatus','taxonName'),
( 'Watermelons','Citrullus vulgaris','taxonName'),
( 'Lemons and limes','Citrus aurantiifolia','taxonName'),
( 'Lemons and limes','Citrus limon','taxonName'),
( 'Citron','Citrus medica','taxonName'),
( 'Chinotto','Citrus myrtifolia','taxonName'),
( 'Grapefruits','Citrus paradisi','taxonName'),
( 'Mandarines','Citrus reticulata','taxonName'),
( 'Oranges','Citrus sinensis','taxonName'),
( 'Lemons and limes','Citrus xlimon','taxonName'),
( 'Grapefruits','Citrus xparadisi','taxonName'),
( 'Oranges','Citrus xsinensis','taxonName'),
( 'Spider plant','Cleome gynandra','taxonName'),
( 'Coconuts','Cocos nucifera','taxonName'),
( 'Coffee','Coffea arabica','taxonName'),
( 'Coffee','Coffea canephora','taxonName'),
( 'Adlay','Coix lacryma-jobi','taxonName'),
( 'Kola nuts','Cola acuminata','taxonName'),
( 'Kola nuts','Cola anomala','taxonName'),
( 'Kola nuts','Cola nitida','taxonName'),
( 'Kola nuts','Cola verticillata','taxonName'),
( 'Taro','Colocasia esculenta','taxonName'),
( 'Jute','Corchorus capsularis','taxonName'),
( 'Jute','Corchorus olitorius','taxonName'),
( 'Coriander','Coriandrum sativum','taxonName'),
( 'Coronilla','Coronilla varia','taxonName'),
( 'Hazelnuts','Corylus avellana','taxonName'),
( 'Hazelnuts','Corylus colurna','taxonName'),
( 'Crambe','Crambe abyssinica','taxonName'),
( 'Crambe','Crambe hispanica','taxonName'),
( 'Azarole','Crataegus azarolus','taxonName'),
( 'Saffron','Crocus sativus','taxonName'),
( 'Sunn hemp','Crotalaria juncea','taxonName'),
( 'Purging croton','Croton tiglium','taxonName'),
( 'West Indian Gherkin','Cucumis anguria','taxonName'),
( 'Melons','Cucumis melo','taxonName'),
( 'Cucumbers and gherkins','Cucumis sativus','taxonName'),
( 'Cushaw','Cucurbita argyrosperma','taxonName'),
( 'Fig leaf gourd','Cucurbita ficifolia','taxonName'),
( 'Pumpkin','Cucurbita maxima','taxonName'),
( 'Butternut squash','Cucurbita moschata','taxonName'),
( 'Zucchini','Cucurbita pepo','taxonName'),
( 'Cumin','Cuminum cyminum','taxonName'),
( 'Turmeric','Curcuma longa','taxonName'),
( 'Quinces','Cydonia oblonga','taxonName'),
( 'Citronella','Cymbopogon citratus','taxonName'),
( 'Citronella','Cymbopogon nardus','taxonName'),
( 'Citronella','Cymbopogon winterianus','taxonName'),
( 'Artichokes','Cynara cardunculus','taxonName'),
( 'Chufa','Cyperus esculentus','taxonName'),
( 'Dactylis','Dactylis glomerata','taxonName'),
( 'Carrots','Daucus carota','taxonName'),
( 'Desmodium','Desmodium intortum','taxonName'),
( 'Desmodium','Desmodium uncinatum','taxonName'),
( 'Fonio','Digitaria exilis','taxonName'),
( 'Fonio','Digitaria iburua','taxonName'),
( 'Longan','Dimocarpus longan','taxonName'),
( 'Yams','Dioscorea alata','taxonName'),
( 'Yams','Dioscorea cayennensis','taxonName'),
( 'Yams','Dioscorea rotundata','taxonName'),
( 'Persimmons','Diospyros kaki','taxonName'),
( 'Durian','Durio zibethinus','taxonName'),
( 'Jelutong','Dyera costulata','taxonName'),
( 'Japanese millet','Echinochloa esculenta','taxonName'),
( 'Japanese millet','Echinochloa frumentacea','taxonName'),
( 'Oil palm','Elaeis guineensis','taxonName'),
( 'Oil palm','Elaeis oleifera','taxonName'),
( 'Cardamoms','Elettaria cardamomum','taxonName'),
( 'Finger millet','Eleusine coracana','taxonName'),
( 'Teff','Eragrostis tef','taxonName'),
( 'Loquat','Eriobotrya japonica','taxonName'),
( 'Buckwheat','Fagopyrum esculentum','taxonName'),
( 'Buckwheat','Fagopyrum tataricum','taxonName'),
( 'Beech nut','Fagus sylvatica','taxonName'),
( 'Festuca','Festuca arundinacea','taxonName'),
( 'Festuca','Festuca gigantea','taxonName'),
( 'Festuca','Festuca heterophylla','taxonName'),
( 'Festuca','Festuca ovina','taxonName'),
( 'Festuca','Festuca pratensis','taxonName'),
( 'Festuca','Festuca rubra','taxonName'),
( 'Figs','Ficus carica','taxonName'),
( 'Fennel','Foeniculum vulgare','taxonName'),
( 'Kumquat','Fortunella japonica','taxonName'),
( 'Strawberries','Fragaria ananassa','taxonName'),
( 'Strawberries','Fragaria xananassa','taxonName'),
( 'Giant cabuya','Furcraea foetida','taxonName'),
( 'Fique','Furcraea macrophylla','taxonName'),
( 'Galactia','Galactia striata','taxonName'),
( 'Mangosteen','Garcinia mangostana','taxonName'),
( 'Huckleberry','Gaylussacia baccata','taxonName'),
( 'Soybeans','Glycine max','taxonName'),
( 'Licorice','Glycyrrhiza glabra','taxonName'),
( 'Cotton','Gossypium herbaceum','taxonName'),
( 'Cotton','Gossypium hirsutum','taxonName'),
( 'Noog','Guizotia abyssinica','taxonName'),
( 'Spider plant','Gynandropsis gynandra','taxonName'),
( 'Hedysarum','Hedysarum coronarium','taxonName'),
( 'Sunflowers','Helianthus annuus','taxonName'),
( 'Jerusalem artichoke','Helianthus tuberosus','taxonName'),
( 'Rubber, natural','Hevea brasiliensis','taxonName'),
( 'Kenaf','Hibiscus cannabinus','taxonName'),
( 'Roselle','Hibiscus sabdariffa','taxonName'),
( 'Barley','Hordeum vulgare','taxonName'),
( 'Hops','Humulus lupulus','taxonName'),
( 'Mate','Ilex paraguariensis','taxonName'),
( 'Badian','Illicium verum','taxonName'),
( 'Indigofera','Indigofera hirsuta','taxonName'),
( 'Indigofera','Indigofera spicata','taxonName'),
( 'Indigofera','Indigofera suffruticosa','taxonName'),
( 'Sweetpotatoes','Ipomoea batatas','taxonName'),
( 'Physic nut','Jatropha curcas','taxonName'),
( 'Walnuts','Juglans nigra','taxonName'),
( 'Walnuts','Juglans regia','taxonName'),
( 'Lablab','Lablab purpureus','taxonName'),
( 'Lettuce','Lactuca sativa','taxonName'),
( 'Calabash','Lagenaria siceraria','taxonName'),
( 'Grasspea','Lathyrus sativus','taxonName'),
( 'Bay leaf','Laurus nobilis','taxonName'),
( 'Lavender','Lavandula spica','taxonName'),
( 'Lentils','Lens culinaris','taxonName'),
( 'Maca','Lepidium meyenii','taxonName'),
( 'Cress','Lepidium sativum','taxonName'),
( 'Lespedeza','Lespedeza cuneata','taxonName'),
( 'Lespedeza','Lespedeza stipulacea','taxonName'),
( 'Lespedeza','Lespedeza striata','taxonName'),
( 'Leucaena','Leucaena leucocephala','taxonName'),
( 'Oiticica','Licania rigida','taxonName'),
( 'Flax','Linum usitatissimum','taxonName'),
( 'Litchi','Litchi chinensis','taxonName'),
( 'Lolium','Lolium hybridum','taxonName'),
( 'Lolium','Lolium multiflorum','taxonName'),
( 'Lolium','Lolium perenne','taxonName'),
( 'Lolium','Lolium rigidum','taxonName'),
( 'Lolium','Lolium temulentum','taxonName'),
( 'Lotus','Lotus corniculatus','taxonName'),
( 'Lotus','Lotus subbiflorus','taxonName'),
( 'Lotus','Lotus uliginosus','taxonName'),
( 'Lupins','Lupinus albus','taxonName'),
( 'Lupins','Lupinus angustifolius','taxonName'),
( 'Lupins','Lupinus luteus','taxonName'),
( 'Lupins','Lupinus mutabilis','taxonName'),
( 'Albardine','Lygeum spartum','taxonName'),
( 'Macadamia nut','Macadamia integrifolia','taxonName'),
( 'Macadamia nut','Macadamia tetraphylla','taxonName'),
( 'Macroptilium','Macroptilium atropurpureum','taxonName'),
( 'Mahuwa','Madhuca longifolia','taxonName'),
( 'Apple','Malus domestica','taxonName'),
( 'Mammee','Mammea americana','taxonName'),
( 'Mango','Mangifera indica','taxonName'),
( 'Ceara','Manihot carthagenensis','taxonName'),
( 'Cassava','Manihot esculenta','taxonName'),
( 'Ceara','Manihot glaziovii','taxonName'),
( 'Sapodilla','Manilkara zapota','taxonName'),
( 'Arrowroot','Maranta arundinacea','taxonName'),
( 'Alfalfa','Medicago arborea','taxonName'),
( 'Alfalfa','Medicago falcata','taxonName'),
( 'Alfalfa','Medicago rigidula','taxonName'),
( 'Alfalfa','Medicago sativa','taxonName'),
( 'Alfalfa','Medicago scutellata','taxonName'),
( 'Alfalfa','Medicago truncatula','taxonName'),
( 'Melilotus','Melilotus albus','taxonName'),
( 'Melilotus','Melilotus officinalis','taxonName'),
( 'Peppermint','Mentha piperita','taxonName'),
( 'Peppermint','Mentha xpiperita','taxonName'),
( 'Medlar','Mespilus germanica','taxonName'),
( 'Sago palm','Metroxylon sagu','taxonName'),
( 'Mauka','Mirabilis expansa','taxonName'),
( 'Mulberry','Morus alba','taxonName'),
( 'Mulberry','Morus nigra','taxonName'),
( 'Mulberry','Morus rubra','taxonName'),
( 'Velvet bean','Mucuna pruriens','taxonName'),
( 'Bananas','Musa acuminata','taxonName'),
( 'Plantains','Musa balbisiana','taxonName'),
( 'Abaca','Musa textilis','taxonName'),
( 'Nutmeg','Myristica fragrans','taxonName'),
( 'Myrtle','Myrtus communis','taxonName'),
( 'Watercress','Nasturtium officinale','taxonName'),
( 'Caroa','Neoglaziovia variegata','taxonName'),
( 'Neonotonia','Neonotonia wightii','taxonName'),
( 'Rambutan','Nephelium lappaceum','taxonName'),
( 'Tobacco','Nicotiana tabacum','taxonName'),
( 'Basil','Ocimum basilicum','taxonName'),
( 'Water dropwort','Oenanthe javanica','taxonName'),
( 'Olives','Olea europaea','taxonName'),
( 'Onobrychis','Onobrychis viciifolia','taxonName'),
( 'Prickly pear','Opuntia ficus-indica','taxonName'),
( 'Marjoram','Origanum majorana','taxonName'),
( 'Oregano','Origanum vulgare','taxonName'),
( 'Ornithopus','Ornithopus sativus','taxonName'),
( 'African rice','Oryza glaberimma','taxonName'),
( 'Asian rice','Oryza sativa','taxonName'),
( 'Oca','Oxalis tuberosa','taxonName'),
( 'Ahipa','Pachyrhizus ahipa','taxonName'),
( 'Jicama','Pachyrhizus erosus','taxonName'),
( 'Gutta-percha','Palaquium gutta','taxonName'),
( 'Proso millet','Panicum miliaceum','taxonName'),
( 'Poppies','Papaver somniferum','taxonName'),
( 'Guayule','Parthenium argentatum','taxonName'),
( 'Kodo millet','Paspalum scrobiculatum','taxonName'),
( 'Passionfruit','Passiflora edulis','taxonName'),
( 'Passionfruit','Passiflora ligularis','taxonName'),
( 'Parsnip','Pastinaca sativa','taxonName'),
( 'Pearl millet','Pennisetum glaucum','taxonName'),
( 'Pearl millet','Pennisetum glaucum','taxonName'),
( 'Perilla','Perilla frutescens','taxonName'),
( 'Avocado','Persea americana','taxonName'),
( 'Parsley','Petroselinum crispum','taxonName'),
( 'Phalaris','Phalaris aquatica','taxonName'),
( 'Phalaris','Phalaris arundinacea','taxonName'),
( 'Canary seed','Phalaris canariensis','taxonName'),
( 'Tepary bean','Phaseolus acutifolius','taxonName'),
( 'Runner bean','Phaseolus coccineus','taxonName'),
( 'Year bean','Phaseolus dumosus','taxonName'),
( 'Lima bean','Phaseolus lunatus','taxonName'),
( 'Common bean','Phaseolus vulgaris','taxonName'),
( 'Phleum','Phleum pratense','taxonName'),
( 'Dates','Phoenix dactylifera','taxonName'),
( 'New Zealand flax','Phormium tenax','taxonName'),
( 'Bamboo shoot','Phyllostachys edulis','taxonName'),
( 'Tomatillo','Physalis ixocarpa','taxonName'),
( 'Tomatillo','Physalis peruviana','taxonName'),
( 'Tomatillo','Physalis philadelphica','taxonName'),
( 'Tomatillo','Physalis pubescens','taxonName'),
( 'Allspice','Pimenta dioica','taxonName'),
( 'Anise','Pimpinella anisum','taxonName'),
( 'Pine nut','Pinus pinea','taxonName'),
( 'Pepper','Piper nigrum','taxonName'),
( 'Pistachios','Pistacia vera','taxonName'),
( 'Peas','Pisum sativum','taxonName'),
( 'Poa','Poa alpina','taxonName'),
( 'Poa','Poa annua','taxonName'),
( 'Poa','Poa pratensis','taxonName'),
( 'Pongamia oil','Pongamia glabra','taxonName'),
( 'Mamey sapote','Pouteria sapota','taxonName'),
( 'Prosopis','Prosopis affinis','taxonName'),
( 'Prosopis','Prosopis alba','taxonName'),
( 'Prosopis','Prosopis chilensis','taxonName'),
( 'Prosopis','Prosopis nigra','taxonName'),
( 'Prosopis','Prosopis pallida','taxonName'),
( 'Apricot','Prunus armeniaca','taxonName'),
( 'Cherries','Prunus avium','taxonName'),
( 'Plums','Prunus cerasifera','taxonName'),
( 'Cherries','Prunus cerasus','taxonName'),
( 'Plums','Prunus domestica','taxonName'),
( 'Almonds','Prunus dulcis','taxonName'),
( 'Peaches and nectarines','Prunus persica','taxonName'),
( 'Plums','Prunus salicina','taxonName'),
( 'Guavas','Psidium guajava','taxonName'),
( 'Winged bean','Psophocarpus tetragonolobus','taxonName'),
( 'Pueraria','Pueraria phaseoloides','taxonName'),
( 'Pomegranate','Punica granatum','taxonName'),
( 'Pears','Pyrus communis','taxonName'),
( 'Pears','Pyrus pyrifolia','taxonName'),
( 'Pears','Pyrus ussuriensis','taxonName'),
( 'Radish','Raphanus sativus','taxonName'),
( 'Rhubarb','Rheum rhabarbarum','taxonName'),
( 'Rhynchosia','Rhynchosia minima','taxonName'),
( 'Rhynchosia','Rhynchosia reticulata','taxonName'),
( 'Currants','Ribes nigrum','taxonName'),
( 'Currants','Ribes rubrum','taxonName'),
( 'Gooseberries','Ribes uva-crispa','taxonName'),
( 'Castor bean','Ricinus communis','taxonName'),
( 'Rosemary','Rosmarinus officinalis','taxonName'),
( 'Raspberries','Rubus idaeus','taxonName'),
( 'Raspberries','Rubus occidentalis','taxonName'),
( 'Raspberries','Rubus plicatus','taxonName'),
( 'Sorrel','Rumex acetosa','taxonName'),
( 'Sugarcane','Saccharum officinarum','taxonName'),
( 'Salsola','Salsola vermiculata','taxonName'),
( 'Elderberry','Sambucus nigra','taxonName'),
( 'Carneros Yucca','Samuela carnerosana','taxonName'),
( 'Snake plant','Sansevieria trifasciata','taxonName'),
( 'Tallowtree','Sapium sebiferum','taxonName'),
( 'Tallowtree','Sapium sebiferum','taxonName'),
( 'Savory','Satureja hortensis','taxonName'),
( 'Savory','Satureja montana','taxonName'),
( 'Black salsify','Scorzonera hispanica','taxonName'),
( 'Rye','Secale cereale','taxonName'),
( 'Chayote','Sechium edule','taxonName'),
( 'Sesame','Sesamum indicum','taxonName'),
( 'Sesbania','Sesbania sesban','taxonName'),
( 'Foxtail millet','Setaria italica','taxonName'),
( 'Tallowtree','Shorea aptera','taxonName'),
( 'Tallowtree','Shorea aptera','taxonName'),
( 'Shala tree','Shorea robusta','taxonName'),
( 'Tallowtree','Shorea stenocarpa','taxonName'),
( 'Tallowtree','Shorea stenocarpa','taxonName'),
( 'Jojoba','Simmondsia chinensis','taxonName'),
( 'Yacon','Smallanthus sonchifolius','taxonName'),
( 'African eggplant','Solanum aethiopicum','taxonName'),
( 'Potatoes','Solanum ajanhuiri','taxonName'),
( 'Black nightshade','Solanum americanum','taxonName'),
( 'Tree tomato','Solanum betaceum','taxonName'),
( 'Potatoes','Solanum curtilobum','taxonName'),
( 'Potatoes','Solanum juzepczukii','taxonName'),
( 'Tomatoes','Solanum lycopersicum','taxonName'),
( 'Eggplant','Solanum melongena','taxonName'),
( 'Pepino','Solanum muricatum','taxonName'),
( 'Naranjilla','Solanum quitoense','taxonName'),
( 'Potatoes','Solanum tuberosum','taxonName'),
( 'Service tree','Sorbus domestica','taxonName'),
( 'Sorghum','Sorghum bicolor','taxonName'),
( 'Spinach','Spinacia oleracea','taxonName'),
( 'Mombin','Spondias mombin','taxonName'),
( 'Mombin','Spondias purpurea','taxonName'),
( 'Tallowtree','Stillingia sebifera','taxonName'),
( 'Tallowtree','Stillingia sebifera','taxonName'),
( 'Esparto','Stipa tenacissima','taxonName'),
( 'Stylosanthes','Stylosanthes hamata','taxonName'),
( 'Stylosanthes','Stylosanthes humilis','taxonName'),
( 'Stylosanthes','Stylosanthes scabra','taxonName'),
( 'Cloves','Syzygium aromaticum','taxonName'),
( 'Ceylon-spinach','Talinum fruticosum','taxonName'),
( 'Tamarind','Tamarindus indica','taxonName'),
( 'New Zealand spinach','Tetragonia tetragonoides','taxonName'),
( 'Cocoa','Theobroma cacao','taxonName'),
( 'Thyme','Thymus vulgaris','taxonName'),
( 'Salsify','Tragopogon porrifolius','taxonName'),
( 'Tallowtree','Triadica sebifera','taxonName'),
( 'Snake gourd','Trichosanthes cucumerina','taxonName'),
( 'Clovers','Trifolium agrocicerum','taxonName'),
( 'Clovers','Trifolium alexandrinum','taxonName'),
( 'Clovers','Trifolium alpestre','taxonName'),
( 'Clovers','Trifolium ambiguum','taxonName'),
( 'Clovers','Trifolium angustifolium','taxonName'),
( 'Clovers','Trifolium arvense','taxonName'),
( 'Clovers','Trifolium hybridum','taxonName'),
( 'Clovers','Trifolium incarnatum','taxonName'),
( 'Clovers','Trifolium pratense','taxonName'),
( 'Clovers','Trifolium pratense','taxonName'),
( 'Clovers','Trifolium repens','taxonName'),
( 'Clovers','Trifolium repens','taxonName'),
( 'Clovers','Trifolium resupinatum','taxonName'),
( 'Clovers','Trifolium rueppellianum','taxonName'),
( 'Clovers','Trifolium semipilosum','taxonName'),
( 'Clovers','Trifolium subterraneum','taxonName'),
( 'Clovers','Trifolium vesiculosum','taxonName'),
( 'Fenugreek','Trigonella foenum-graecum','taxonName'),
( 'Tripsacum','Tripsacum laxum','taxonName'),
( 'Triticale','Triticosecale blaringhemii','taxonName'),
( 'Triticale','Triticosecale neoblaringhemii','taxonName'),
( 'Triticale','Triticosecale schlanstedtense','taxonName'),
( 'Triticale','Triticosecale semisecale','taxonName'),
( 'Wheat','Triticum ×petropavlovskyi','taxonName'),
( 'Wheat','Triticum aestivum','taxonName'),
( 'Wheat','Triticum durum','taxonName'),
( 'Wheat','Triticum flaksbergeri','taxonName'),
( 'Wheat','Triticum ispahanicum','taxonName'),
( 'Wheat','Triticum kiharae','taxonName'),
( 'Wheat','Triticum monococcum','taxonName'),
( 'Wheat','Triticum timopheevii','taxonName'),
( 'Wheat','Triticum turgidum','taxonName'),
( 'Wheat','Triticum vavilovii','taxonName'),
( 'Wheat','Triticum zhukovsky','taxonName'),
( 'Mashua','Tropaeolum tuberosum','taxonName'),
( 'Ulluco','Ullucus tuberosus','taxonName'),
( 'Caesarweed','Urena lobata','taxonName'),
( 'Caesarweed','Urena sinuata','taxonName'),
( 'Brachiaria','Urochloa brizantha','taxonName'),
( 'Brachiaria','Urochloa humidicola','taxonName'),
( 'Brachiaria','Urochloa ruziziensis','taxonName'),
( 'Blueberry','Vaccinium angustifolium','taxonName'),
( 'Blueberry','Vaccinium corymbosum','taxonName'),
( 'Cranberries','Vaccinium macrocarpon','taxonName'),
( 'Blueberry','Vaccinium virgatum','taxonName'),
( 'Vanilla','Vanilla planifolia','taxonName'),
( 'Vanilla','Vanilla pompona','taxonName'),
( 'Vanilla','Vanilla tahitensis','taxonName'),
( 'Vanilla','Vanilla xtahitensis','taxonName'),
( 'Babaco','Vasconcellea xheilbornii','taxonName'),
( 'Tung nuts','Vernicia fordii','taxonName'),
( 'Vetch','Vicia articulata','taxonName'),
( 'Faba beans','Vicia faba','taxonName'),
( 'Vetch','Vicia narbonensis','taxonName'),
( 'Vetch','Vicia pannonica','taxonName'),
( 'Vetch','Vicia sativa','taxonName'),
( 'Mat bean','Vigna aconitifolia','taxonName'),
( 'Adzuki bean','Vigna angularis','taxonName'),
( 'Black gram','Vigna mungo','taxonName'),
( 'Mung bean','Vigna radiata','taxonName'),
( 'Bambara bean','Vigna subterranea','taxonName'),
( 'Rice bean','Vigna umbellata','taxonName'),
( 'Cowpeas','Vigna unguiculata','taxonName'),
( 'Karite nuts','Vitellaria paradoxa','taxonName'),
( 'Grapes','Vitis vinifera','taxonName'),
( 'Yautia, cocoyam','Xanthosoma sagittifolium','taxonName'),
( 'Triticale','xTriticosecale blaringhemii','taxonName'),
( 'Triticale','xTriticosecale neoblaringhemii','taxonName'),
( 'Triticale','xTriticosecale schlanstedtense','taxonName'),
( 'Triticale','xTriticosecale semisecale','taxonName'),
( 'Carneros Yucca','Yucca carnerosana','taxonName'),
( 'Maize','Zea mays','taxonName'),
( 'Ginger','Zingiber officinale','taxonName'),
( 'Wildrice','Zizania palustris','taxonName'),
( 'Jujube','Zizyphus jujuba','taxonName'),
( 'Zornia','Zornia latifolia','taxonName');























































































































































































































































































































































































































































































































































































































































