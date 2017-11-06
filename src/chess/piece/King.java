package chess.piece;

import chess.agent.Move;
import chess.agent.Player;

public class King extends Piece {

    public King(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "R" : "r");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
    }
}