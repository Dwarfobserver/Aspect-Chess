package aspects;

import chess.agent.Move;
import chess.agent.Player;
import chess.piece.*;

public aspect VariousFixes {

    String around(Piece piece):
            execution(public String Bishop.toString()) && this(piece)
    {
        return ((piece.getPlayer() == Player.WHITE) ? "B" : "b");
    }

    String around(Player player):
            execution(String Player.getColorName()) && this(player)
    {
        return ((player.getColor() == Player.BLACK) ? "White" : "Black");
    }

    String around(Move move):
            execution(String Move.toString()) && this(move)
    {
        return (char) ('a' + move.xI) + "" + (move.yI + 1) +
               (char) ('a' + move.xF) + "" + (move.yF + 1);
    }
}
