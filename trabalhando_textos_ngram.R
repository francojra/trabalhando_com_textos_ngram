
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

freq_2 <- casmurro_2 %>%
  count(palavra, sort = TRUE)
view(freq_2)

# Usando ngram = 3 -------------------------------------------------------------------------------------------------------------------------

casmurro_3 <- unnest_tokens(casmurro, palavra, Texto, token = "ngrams", n = 3)
view(casmurro_3)

### Frequência

freq_3 <- casmurro_3 %>%
  count(palavra, sort = TRUE)
view(freq_3)

# Exercício 1 -------------------------------------------------------------------------------------------------------------------------------

### Baixe um texto de tamanho relativamente grande. Recomendável usar o pacote 'gutenbergr'
### ou 'rvest'.

library(rvest)

### "Serenata" é um projeto aberto no qual usa data science (ciência de dados) – a mesma 
### tecnolgia usada por gigantes como Google, Facebook e Netflix – com o objetivo de 
### monitorar os gastos públicos e compartilhar informações de forma acessível a todos.

### Explicado o projeto Serenata, voltamos ao Web Scraping. A coleta de dados será sobre 
### o 'Jarbas', que é a plataforma onde ficam armazenados os documentos considerados 
### suspeitos.

url <- "https://jarbas.serenata.ai/dashboard/chamber_of_deputies/reimbursement/"
jarbas_webpage <- read_html(url)

### Passo 2: Agora, a melhor parte da biblioteca rvest é que você pode extrair os dados 
### de html em forma de nós, o que significa que você pode selecionar imediatamente 
### quais os nós através dos ids ou classes css e extrair o texto das tags do html. 
### Então eu fui para o meu url e abri o “firebug ” no navegador e percebi que os nomes 
### dos deputados foram encapsulados na classe css “.field-congressperson_name ”, usando 
### esta classe css que posso extrair todos os nomes dos deputados na página da web.

### Existem 2 funções que usaremos aqui:

### html_nodes: Use esta função para extrair os nós que desejamos (neste caso nós com 
### “.field-congressperson_name” como classe css
### html_text: Use esta função para extrair o texto entre dos nós html (neste caso, 
### os nomes de nossos representantes)

#Scraping  usando classe css ‘field-congressperson_name’
jarbas_names_html <- html_nodes(jarbas_webpage, '.field-congressperson_name')
jarbas_names <- html_text(jarbas_names_html)
head(jarbas_names)

### Da mesma forma, agora farei isso para todos os outros atributos: SUBQUOTA TRANSLATED, 
### FORNECEDOR. Cada um desses atributos tem suas próprias classes css: 
### field-subquota_translated, field-supplier_info.

#SUBQUOTA TRANSLATED
jarbas_subquota_html <- html_nodes(jarbas_webpage, '.field-subquota_translated')
jarbas_subquota <- html_text(jarbas_subquota_html)
head(jarbas_subquota)

#Fornecedor
jarbas_provider_html <- html_nodes(jarbas_webpage, '.field-supplier_info')
jarbas_provider <- html_text(jarbas_provider_html)
head(jarbas_provider)

### A seguir serão mostrados o valor do reembolso, note que eles são extraídos em tipo
### de variável caracter: Ex: R$ 139,76, R$ 40,23. Entretanto, como desejamos manipular 
### esses números, precisamos convertê-los para tipo de variável numérica, dessa forma 
### será utilizado a biblioteca: “Stringr” mais especificamente a função: str_extract. 
### Segue o script para conversão da variável.

library(stringr)
#valores em Real
jarbas_value_html <- html_nodes(jarbas_webpage, '.field-value')
jarbas_value <- html_text(jarbas_value_html)
head(jarbas_value)

#dados extraídos na forma de caracter, vamos converter para tipo numérico
jarbas_value <- as.numeric(sub(",",".", str_extract(jarbas_value, 
                                                   pattern = "\\d+")))
head(jarbas_value, 50)

### Passo 3: Com essas informações disponíveis, vamos gerar um dataframe. Para facilitar 
### a visualização, apenas o primeiro nome de cada deputado foi selecionado.

#Combinando todas as características obtidas
jarbas_names <- str_extract(jarbas_names, pattern = boundary("word"))
jarbas_df <- data.frame(
  Name = jarbas_names,
  Subquota = jarbas_subquota,
  Provider = jarbas_provider,
  Value = jarbas_value
  )
str(jarbas_df)
view(jarbas_df)

### Passo 4: Numa primeira análise, podemos utilizar gráfico entre o valor do reembolso 
### e o nome dos deputados. Foram utilizados as 80 primeiras linhas do data.frame e uma 
### biblioteca ggplot2 para geração do gráfico.

library(ggplot2)

jarbas_df <- jarbas_df[1:80,]

ggplot(
  jarbas_df, aes(Value, Name, colour = Subquota)) +
  geom_point() +
  labs(title = "", x = "pedidos de reembolso (R$)",
       y = "deputados", colour = "SUBQUOTA TRANSLATED")

### Fonte: http://estatidados.com.br/introducao-a-web-scraping-com-r/

url2 <- "https://www.bbc.com/portuguese/brasil-61099201"
bbc <- read_html(url2)


# Exercício 2 ------------------------------------------------------------------------------------------------------------------------------

texto <- html_nodes(bbc, '.bbc-19j92fr')
texto1 <- html_text(texto)
head(texto1)

library(tm)

stopwords("pt") # Indica algumas palavras em português ("pt") que não tem muita utilidade 
## para as análises

txt_bbc <- removeWords(texto1, stopwords("pt")) # Remove palavras desnecessárias
view(txt_bbc)

### Criando data frame e gráfico de frequência de palavras

txt_bbc <- data.frame("Linha" = 1:length(txt_bbc), "Texto" = txt_bbc)
view(txt_bbc)

txt_bbc <- unnest_tokens(txt_bbc, Palavra, Texto) # Coluna palavra substitui coluna 
# texto
view(txt_bbc)

freq_bbc <- txt_bbc %>%
  count(Palavra, sort = TRUE)
view(freq_bbc)

### As palavras mais frequentes

freq5_bbc <- filter(freq_bbc, n > 5) %>%
  arrange(desc(n))
view(freq5_bbc)

### Gráfico

ggplot(freq5_bbc) +
  geom_col(aes(x = Palavra, y = n))

ggplot(freq5_bbc) +
  geom_col(aes(y = n, x = reorder(Palavra, -n)), fill = "forestgreen") +
  labs(y = "Frequência", x = "Palavras do site da BBC") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

### Criar  dataframe e gráfico de frequência de ngrams ( 3 e 4 palavras)

texto <- html_nodes(bbc, '.bbc-19j92fr')
texto1 <- html_text(texto)
head(texto1)

txt_bbc <- data.frame("Linha" = 1:length(texto1), "Texto" = texto1)
view(txt_bbc)

### ngram = 3

txt_bbc2 <- unnest_tokens(txt_bbc, Palavra, Texto, token = "ngrams", n = 3) 
view(txt_bbc2)

### Frequência ngram = 3

freq_bbc <- txt_bbc2 %>%
  count(Palavra, sort = TRUE) %>%
  drop_na() 
view(freq_bbc)

freq_ngram_bbc <- filter(freq_bbc, n >= 2) %>%
  arrange(desc(n), na.rm = TRUE) 
view(freq_ngram_bbc)

### Gráfico ngram = 3

ggplot(freq_ngram_bbc) +
  geom_col(aes(x = Palavra, y = n))

ggplot(freq_ngram_bbc) +
  geom_col(aes(y = n, x = reorder(Palavra, -n)), fill = "orange") +
  labs(y = "Frequência", x = "Palavras do site da BBC") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

### ngram = 4

txt_bbc3 <- unnest_tokens(txt_bbc, Palavra, Texto, token = "ngrams", n = 4) 
view(txt_bbc3)

### Frequência ngram = 4

freq_bbc <- txt_bbc3 %>%
  count(Palavra, sort = TRUE) %>%
  drop_na() 
view(freq_bbc)

freq_ngram_bbc <- filter(freq_bbc, n >= 2) %>%
  arrange(desc(n), na.rm = TRUE) 
view(freq_ngram_bbc)

### Gráfico ngram = 4

ggplot(freq_ngram_bbc) +
  geom_col(aes(x = Palavra, y = n))

ggplot(freq_ngram_bbc) +
  geom_col(aes(y = n, x = reorder(Palavra, -n)), fill = "steelblue") +
  labs(y = "Frequência", x = "Palavras do site da BBC") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
