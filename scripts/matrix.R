# Cargar libraries
library(igraph)
library(dplyr)
library(ggplot2)

# Cargar datasets
edge_list <- read.CVS(“edgelist”, stringsAsFactors = FALSE)
node_list <- read.CVS(“nodelist”, stringsAsFactors = FALSE)

# Crear iGraph
graph <- graph.data.frame(edge_list, directed = TRUE, vertices = node_list)

# Calcular propiedades de la red y adicionarle atributos a los nodos
# El código desde aquí es adaptado de http://github.com/mdlincoln/
V(graph)$comm <- membership(optimal.community(graph))
V(graph)$degree <- degree(graph)
V(graph)$closeness <- centralization.closeness(graph)$res
V(graph)$betweenness <- centralization.betweenness(graph)$res
V(graph)$eigen <- centralization.evcent(graph)$vector

# Regenerar dataframes con cálculos de atributos de red
node_list <- get.data.frame(graph, what = "vertices")

# Calcular comunidades
edge_list <- get.data.frame(graph, what = "edges") %>%
    inner_join(node_list %>% select(name, comm), by = c("from" = "name")) %>%
    inner_join(node_list %>% select(name, comm), by = c("to" = "name")) %>%
    mutate(group = ifelse(comm.x == comm.y, comm.x, NA) %>% factor())

# Crear un vector con el nombre de todos los nodos
all_nodes <- sort(node_list$name)

# Ajustar el ‘to’ y ‘from’ así son iguales a la lista de
# nombre de todos los nodos
plot_data <- edge_list %>% mutate(
    to = factor(to, levels = all_nodes),
    from = factor(from, levels = all_nodes))

# Crear la matriz de adyacencia
ggplot(plot_data, aes(x = from, y = to, fill = group)) +
    geom_raster() +
    theme_bw() +
    scale_x_discrete(drop = FALSE) +
    scale_y_discrete(drop = FALSE) +
    theme(
      axis.text.x = element_text(angle = 270, hjust = 0),
      aspect.ratio = 1,
      legend.position = "none")

# Crear un vector con los nombres ordenados según comunidad

comm <- c("")

#Reordenar la edge_list en función del vector que acabás de crear
name_order <- (node_list %>% arrange(comm))$name
plot_data <- edge_list %>% mutate(
    to = factor(to, levels = name_order),
    from = factor(from, levels = name_order))

# MIT License

# Copyright (c) 2015 Matthew Lincoln

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Dale ‘run’ al plot de nuevo
