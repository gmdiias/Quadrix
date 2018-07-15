%  Para executar os testes, utilize o comando make testar (no diret�rio
%  quadrix). Voc� tamb�m pode executar testes ou conjunto de testes
%  espec�ficos no interpretador prolog. Ap�s carregar o arquivo testes.pl,
%  execute a consulta
%
%  run_tests(quadrix:na_borda_superior). % para executar o teste na_borda_superior
%
%  run_tests(quadrix).                   % para executar os testes b�sicos
%
%  run_tests(quadrix_grandes).           % para executar os testes para os jogos grandes
%
%  run_tests(quadrix_desafio).           % para executar os testes do desafio
%
%  Alguns testes utilizam um jogo com 3 linhas e 5 colunas. Voc� pode
%  visualizar as rela��es de adjac�ncia no esquema a seguir.
%
%   0  1  2  3  4
%   5  6  7  8  9
%  10 11 12 13 14
%
%  Leia o prop�sito de cada predicado no arquivo quadrix.pl.

:- consult(quadrix).
:- use_module(library(plunit)).


:- begin_tests(quadrix).

% Testes para o predicado principal solucao/2
% Veja o predicao teste_caso/1 no final deste arquivo.

test(solucao1x1) :-
    teste_caso(teste1x1).

test(solucao2x2) :-
    teste_caso(teste2x2).

test(solucao3x3) :-
    teste_caso(teste3x3).

% Testes para os demais predicados
% Voc� deve escrever os testes para os novos predicados que voc� definir.

test(na_borda_superior) :-
    jogo_quadrix(Jogo, 3, 5),
    na_borda_superior(Jogo, 0),
    na_borda_superior(Jogo, 1),
    na_borda_superior(Jogo, 2),
    na_borda_superior(Jogo, 3),
    na_borda_superior(Jogo, 4).

test(na_borda_superior, fail) :-
    jogo_quadrix(Jogo, 3, 5),
    na_borda_superior(Jogo, 5).

test(na_borda_esquerda) :-
    jogo_quadrix(Jogo, 3, 3),
    na_borda_esquerda(Jogo, 0),
    na_borda_esquerda(Jogo, 3),
    na_borda_esquerda(Jogo, 6).

test(na_borda_esquerda, fail) :-
    jogo_quadrix(Jogo, 3, 3),
    na_borda_esquerda(Jogo, 1),
    na_borda_esquerda(Jogo, 4),
    na_borda_esquerda(Jogo, 7).


test(pos_acima, A =:= 2) :-
    jogo_quadrix(Jogo, 3, 5),
    % a posi��o acima da posi��o 7 � a posi��o A =:= 2
    pos_acima(Jogo, 7, A).

test(pos_esquerda, A =:= 6) :-
    jogo_quadrix(Jogo, 3, 5),
    % a posi��o acima da posi��o 7 � a posi��o A =:= 2
    pos_esquerda(Jogo, 7, A).

% posi��o 1
%    5
%  8   2
%    7
%
% posi��o 6
%    7
%  9   4
%    6
test(corresponde_acima) :-
    jogo_quadrix(Jogo, 3, 5),
    bloco_pos(Jogo, 1, bloco(5, 2, 7, 8)),
    bloco_pos(Jogo, 6, bloco(7, 4, 6, 9)),
    % n�o tem ningu�m acima de 1, portanto corresponde
    corresponde_acima(Jogo, 1),
    % quem est� acima de 6 � o 1, na borda superior da posi��o 6, tem o 7, e na
    % borda inferior da posi��o 1 tem o 7, portanto corresponde
    corresponde_acima(Jogo, 6).

test(corresponde_acima, fail) :-
    jogo_quadrix(Jogo, 3, 5),
    bloco_pos(Jogo, 1, bloco(5, 2, 7, 8)),
    bloco_pos(Jogo, 6, bloco(3, 4, 6, 9)),
    % n�o corresponde, no lugar do 3 deveria ser 7
    corresponde_acima(Jogo, 6).

:- end_tests(quadrix).


:- begin_tests(quadrix_grande).

test(solucao_grandes) :-
    teste_caso(teste4x4),
    teste_caso(teste5x5),
    teste_caso(teste6x6).

:- end_tests(quadrix_grande).


:- begin_tests(quadrix_desafio).

test(desafio) :-
    teste_caso(teste7x7).

:- end_tests(quadrix_desafio).


teste_caso(Caso) :-
    call(Caso, Blocos, Linhas, Colunas),
    reverse(Blocos, BlocosRev),
    jogo_quadrix(Jogo, Linhas, Colunas),
    % a lista dos blocos � dada na ordem inversa
    solucao(Jogo, BlocosRev),
    quadrix(_, _, R) = Jogo,
    % voc� pode descomentar a linha a seguir para ver o resultado encontrado pelo seu predicado solucao
    % write(R), nl,
    % a resposta deve ser a lista dos blocos na ordem normal
    R == Blocos.

teste1x1(Blocos, 1, 1) :-
    Blocos = [bloco(3, 6, 7, 5)].

teste2x2(Blocos, 2, 2) :-
    Blocos = [
        bloco(3, 4, 7, 9),
        bloco(6, 9, 5, 4),
        bloco(7, 6, 5, 2),
        bloco(5, 3, 6, 6)].

teste3x3(Blocos, 3, 3) :-
    Blocos = [
        bloco(7, 3, 4, 9),
        bloco(3, 4, 8, 3),
        bloco(7, 4, 2, 4),
        bloco(4, 4, 8, 5),
        bloco(8, 3, 6, 4),
        bloco(2, 2, 7, 3),
        bloco(8, 9, 1, 3),
        bloco(6, 6, 6, 9),
        bloco(7, 8, 5, 6)].

teste4x4(Blocos, 4, 4) :-
    Blocos = [
        bloco(7, 7, 4, 8),
        bloco(3, 0, 2, 7),
        bloco(7, 9, 1, 0),
        bloco(1, 6, 3, 9),
        bloco(4, 2, 5, 5),
        bloco(2, 4, 5, 2),
        bloco(1, 5, 7, 4),
        bloco(3, 8, 0, 5),
        bloco(5, 5, 8, 0),
        bloco(5, 5, 9, 5),
        bloco(7, 6, 7, 5),
        bloco(0, 2, 1, 6),
        bloco(8, 7, 9, 5),
        bloco(9, 2, 8, 7),
        bloco(7, 3, 3, 2),
        bloco(1, 0, 4, 3)].

teste5x5(Blocos, 5, 5) :-
    Blocos = [
        bloco(1, 6, 7, 5),
        bloco(4, 0, 0, 6),
        bloco(9, 2, 0, 0),
        bloco(8, 3, 5, 2),
        bloco(0, 4, 5, 3),
        bloco(7, 1, 2, 6),
        bloco(0, 4, 5, 1),
        bloco(0, 0, 3, 4),
        bloco(5, 1, 1, 0),
        bloco(5, 3, 2, 1),
        bloco(2, 9, 1, 0),
        bloco(5, 5, 5, 9),
        bloco(3, 2, 2, 5),
        bloco(1, 0, 6, 2),
        bloco(2, 9, 0, 0),
        bloco(1, 0, 7, 0),
        bloco(5, 0, 7, 0),
        bloco(2, 4, 8, 0),
        bloco(6, 9, 4, 4),
        bloco(0, 0, 6, 9),
        bloco(7, 0, 2, 5),
        bloco(7, 2, 0, 0),
        bloco(8, 6, 1, 2),
        bloco(4, 4, 6, 6),
        bloco(6, 5, 8, 4)].

teste6x6(Blocos, 6, 6) :-
    Blocos = [
        bloco(3, 0, 2, 4),
        bloco(9, 5, 5, 0),
        bloco(1, 1, 8, 5),
        bloco(4, 2, 0, 1),
        bloco(4, 3, 2, 2),
        bloco(8, 0, 0, 3),
        bloco(2, 2, 3, 9),
        bloco(5, 9, 1, 2),
        bloco(8, 2, 3, 9),
        bloco(0, 2, 3, 2),
        bloco(2, 9, 8, 2),
        bloco(0, 6, 9, 9),
        bloco(3, 1, 6, 9),
        bloco(1, 2, 2, 1),
        bloco(3, 0, 8, 2),
        bloco(3, 5, 8, 0),
        bloco(8, 7, 8, 5),
        bloco(9, 4, 8, 7),
        bloco(6, 0, 6, 9),
        bloco(2, 4, 5, 0),
        bloco(8, 7, 6, 4),
        bloco(8, 3, 7, 7),
        bloco(8, 7, 2, 3),
        bloco(8, 7, 1, 7),
        bloco(6, 3, 9, 0),
        bloco(5, 1, 9, 3),
        bloco(6, 9, 8, 1),
        bloco(7, 7, 0, 9),
        bloco(2, 0, 6, 7),
        bloco(1, 3, 7, 0),
        bloco(9, 9, 8, 7),
        bloco(9, 0, 6, 9),
        bloco(8, 1, 6, 0),
        bloco(0, 9, 7, 1),
        bloco(6, 1, 7, 9),
        bloco(7, 8, 1, 1)].

teste7x7(Blocos, 7, 7) :-
    Blocos = [
        bloco(4, 1, 0, 8),
        bloco(7, 8, 1, 1),
        bloco(0, 3, 5, 8),
        bloco(4, 0, 9, 3),
        bloco(9, 7, 1, 0),
        bloco(6, 8, 3, 7),
        bloco(3, 5, 2, 8),
        bloco(0, 9, 5, 8),
        bloco(1, 4, 9, 9),
        bloco(5, 1, 6, 4),
        bloco(9, 3, 1, 1),
        bloco(1, 5, 6, 3),
        bloco(3, 3, 2, 5),
        bloco(2, 0, 4, 3),
        bloco(5, 1, 8, 8),
        bloco(9, 6, 8, 1),
        bloco(6, 5, 2, 6),
        bloco(1, 8, 6, 5),
        bloco(6, 4, 9, 8),
        bloco(2, 8, 2, 4),
        bloco(4, 1, 8, 8),
        bloco(8, 1, 5, 4),
        bloco(8, 2, 0, 1),
        bloco(2, 0, 2, 2),
        bloco(6, 4, 8, 0),
        bloco(9, 7, 7, 4),
        bloco(2, 8, 5, 7),
        bloco(8, 0, 7, 8),
        bloco(5, 6, 0, 8),
        bloco(0, 9, 4, 6),
        bloco(2, 2, 2, 9),
        bloco(8, 9, 5, 2),
        bloco(7, 1, 5, 9),
        bloco(5, 2, 0, 1),
        bloco(7, 9, 6, 2),
        bloco(0, 7, 5, 8),
        bloco(4, 7, 5, 7),
        bloco(2, 9, 1, 7),
        bloco(5, 7, 5, 9),
        bloco(5, 5, 4, 7),
        bloco(0, 8, 5, 5),
        bloco(6, 8, 7, 8),
        bloco(5, 7, 9, 6),
        bloco(5, 0, 2, 7),
        bloco(1, 4, 6, 0),
        bloco(5, 3, 2, 4),
        bloco(4, 9, 6, 3),
        bloco(5, 8, 1, 9),
        bloco(7, 8, 0, 8)].
