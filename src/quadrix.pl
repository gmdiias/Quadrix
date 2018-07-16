%  Este arquivo cont�m a estrutura inicial de um resolvedor do jogo quadrix.
%
%  O predicado principal � solucao/2. Os demais predicados ajudar�o na escrita
%  do predicado principal. Para cada predicado existe um conjunto de testes
%  correspondente no arquivo testes.pl. Voc� deve ler o prop�sito do predicado
%  e os testes e depois escrever o corpo do predicado de maneira a atender o
%  prop�sito e passar nos testes. Comece a escrever a implementa��o do �ltimo
%  predicado para o primeiro (na sequ�ncia inversa que os predicados aparecem
%  neste arquivo). Voc� deve criar os demais predicados auxiliares e escrever
%  os testes correspondentes no arquivo teste.pl.
%
%  Um jogo quadrix � representado por uma estrutura quadrix com 3 argumentos.
%  O primeiro � o n�mero de linhas, o segundo o n�mero de colunas e o terceiro
%  uma lista (de tamanho linhas x colunas) com os blocos que comp�em a solu��o.
%  Inicialmente, os elementos dessa lista de blocos n�o est�o instanciados, eles
%  s�o instanciados pelo predicado solucao/2. Cada bloco � identificado por um
%  n�mero inteiro que corresponde a sua posi��o na lista de blocos. Por
%  exemplo, em um quadrix com 3 linhas e 5 colunas (total de 15 blocos), os
%  blocos s�o enumerados da seguinte forma
%
%   0  1  2  3  4
%   5  6  7  8  9
%  10 11 12 13 14
%
%  Cada bloco � representado por uma estrutura bloco com 4 argumentos. Os
%  argumentos representam os valores da borda superior, direita, inferior e
%  esquerda (sentido hor�rio come�ando do topo). Por exemplo o bloco
%  |  3  |
%  |4   6|  � representado por bloco(3, 6, 7, 4).
%  |  7  |



%% solucao(?Jogo, +Blocos) is semidet
%
%  Verdadeiro se Jogo � um jogo quadrix v�lido para o conjunto Blocos.
%  Blocos cont�m a lista de blocos que devem ser "colocadas" no Jogo.

solucao(Jogo, Blocos) :-
    _ = (Jogo, Blocos), fail.


%% blocos_correspondem(?Jogo, ?Pos) is semidet
%
%  Verdadeiro se o bloco que est� em Pos corresponde com seus adjacentes.
%  Isto �, se o bloco que est� em Pos e seus adjacentes est�o dispostos de
%  maneira que suas bordas adjacentes tenham o mesmo n�mero.

blocos_correspondem(Jogo, Pos) :-
    _ = (Jogo, Blocos), fail.

%% corresponde_acima(+Jogo, +Pos) is semidet
%
%  Verdadeiro se o bloco que est� em Pos corresponde com o bloco que est� acima
%  de Pos em Jogo. Isto �, o valor da borda superior do bloco em Pos deve ser
%  igual ao valor da borda inferior do bloco acima de Pos. Se Pos est� na borda
%  superior, ent�o a posi��o acima corresponde.

corresponde_acima(Jogo, Pos) :-
    \+ pos_acima(Jogo, Pos, PosAcima), !.

corresponde_acima(Jogo, Pos) :-
    pos_acima(Jogo, Pos, PosAcima),
    bloco_pos(Jogo, Pos, B1),
    bloco_pos(Jogo, PosAcima, B2),
    B2 = bloco(_, _, C1, _),
    B1 = bloco(C2, _, _, _),
    C1 =:= C2.

%% corresponde_esquerda(+Jogo, +Pos) is semidet
%
%  Verdadeiro se o bloco que est� em Pos corresponde com o bloco que est� �
%  esquerda de Pos em Jogo. Isto �, o valor da borda esquerda do bloco em Pos
%  deve ser igual ao valor da borda direita do bloco � esquerda de Pos. Se Pos
%  est� na borda esquerda, ent�o a posi��o � esquerda corresponde.

corresponde_esquerda(Jogo, Pos) :-
    \+ pos_esquerda(Jogo, Pos, PosEsquerda), !.

corresponde_esquerda(Jogo, Pos) :-
    pos_esquerda(Jogo, Pos, PosEsquerda),
    bloco_pos(Jogo, Pos, B1),
    bloco_pos(Jogo, PosEsquerda, B2),
    B2 = bloco(_, D1, _, _),
    B1 = bloco(_, _, _, E2),
    D1 =:= E2.


%% na_borda_superior(+Jogo, +Pos) is semidet
%
%  Verdadeiro se Pos � uma posi��o na borda superior de Jogo. Ou seja, Pos est�
%  na primeira linha.

na_borda_superior(Jogo, Pos) :-
    quadrix(_, Colunas, _) = Jogo,
    Pos < Colunas.


%% na_borda_esquerda(+Jogo, +Pos) is semidet
%
%  Verdadeiro se Pos � uma posi��o na borda esquerda de Jogo. Ou seja, Pos est�
%  na primeira coluna.

na_borda_esquerda(Jogo, Pos) :-
    quadrix(_, Colunas, _) = Jogo,
    A is Pos mod Colunas,
    A =:= 0.

%% pos_acima(+Jogo, +Pos, ?Acima) is semidet
%
%  Verdadeiro se a posi��o Acima est� acima de Pos em Jogo.

pos_acima(Jogo, Pos, Acima) :-
    na_borda_superior(Jogo, Pos), !,
    fail.

pos_acima(Jogo, Pos, Acima) :-
    quadrix(_, Colunas, _) = Jogo,
    Acima is Pos - Colunas.


%% pos_esquerda(+Jogo, +Pos, ?Esquerda) is semidet
%
%  Verdadeiro se a posi��o Esquerda est� � esquerda de Pos em Jogo.


pos_esquerda(Jogo, Pos, Esquerda) :-
    na_borda_esquerda(Jogo, Pos), !,
    fail.

pos_esquerda(Jogo, Pos, Esquerda) :-
    Esquerda is Pos - 1.


%% bloco_pos(?Jogo, ?Pos, ?Bloco) is nondet
%
%  Verdadeiro se Bloco est� na posi��o Pos de Jogo.

bloco_pos(Jogo, Pos, Bloco) :-
    quadrix(_, _, Blocos) = Jogo,
    nth0(Pos, Blocos, Bloco).


%% quadrix(-Jogo, ?Linhas, ?Colunas) is semidet
%
%  Verdadeiro se Jogo � um jogo quadrix de tamanho Linhas x Colunas.

jogo_quadrix(quadrix(Linhas, Colunas, Blocos), Linhas, Colunas) :-
    S is Linhas * Colunas,
    length(Blocos, S).
