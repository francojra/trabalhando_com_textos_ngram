
# Trabalhando com textos - ngram -------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data do script: 30/04/22 -----------------------------------------------------------------------------------------------------------------
# Referência: Curso Udemy ------------------------------------------------------------------------------------------------------------------

# Pacotes necessários ------------------------------------------------------------------------------------------------------------------------

library(tidyverse)
library(tidytext) 

# Carregando texto -------------------------------------------------------------------------------------------------------------------------

casmurro <- scan("casmurro.txt", what = "character", sep = "\n", encoding = "UTF-8")

casmurro[27:6393] # Linhas de começo e fim do texto

casmurro <- data.frame("Linha" = 1:length(casmurro), "Texto" = casmurro)
view(casmurro)

# Usando ngram = 2 -------------------------------------------------------------------------------------------------------------------------

### ngrams são pares ou trios de palavras que geralmente aparecem juntas no texto

casmurro_2 <- unnest_tokens(casmurro, palavra, Texto, token = "ngrams", n = 2)
view(casmurro_2)

### Frequência

