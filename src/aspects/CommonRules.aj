package aspects;

import chess.*;
import chess.agent.*;
import chess.piece.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.*;
import java.util.ArrayList;


public aspect CommonRules {
    pointcut onMove(Player player, Move move):
            (execution(public boolean HumanPlayer.move(Move))
          || execution(public boolean StupidAI.move(Move)))
          && this(player) && args(move);

    boolean around(Player player, Move move): onMove(Player, Move) && this(player) && args(move) {

        ValidationData data = new ValidationData();
        data.player = player;
        data.p1 = new Point(move.xI, move.yI);
        data.p2 = new Point(move.xF, move.yF);

        if (!data.checkPositions()) return false;

        data.grid = player.getPlayGround().getGrid();
        data.piece1 = data.grid[data.p1.x][data.p1.y].getPiece();
        data.piece2 = data.grid[data.p2.x][data.p2.y].getPiece();

        if (!data.checkPieces()) return false;

        if (!data.checkMove()) return false;

        if (!data.checkSight()) return false;

        boolean result = proceed(player, move);

        data.handlePromotion();

        return result;
    }

    private static ArrayList<String> promotionNamesInstance;
    private static ArrayList<String> getPromotionNames() {
        if (promotionNamesInstance == null) {
            promotionNamesInstance = new ArrayList<>();
            promotionNamesInstance.add(Bishop.class.getSimpleName());
            promotionNamesInstance.add(Knight.class.getSimpleName());
            promotionNamesInstance.add(Queen. class.getSimpleName());
            promotionNamesInstance.add(Rook.  class.getSimpleName());
        }
        return promotionNamesInstance;
    }

    public class Point {
        int x, y;
        Point(int x, int y) {
            this.x = x;
            this.y = y;
        }
        boolean isOnBoard() {
            return (x >= 0 && x < 8 && y >= 0 && y < 8);
        }
        @Override
        public String toString() {
            return "(" + x + ", " + y + ")";
        }
    }

    public class ValidationData {
        Player player;
        Point p1;
        Point p2;
        Spot[][] grid;
        Piece piece1;
        Piece piece2;

        private boolean onEnemy;
        private Move normalizedMove;

        boolean checkPositions() {
            if (!p1.isOnBoard() || !p2.isOnBoard()) {
                if (player.getColor() == Player.BLACK) System.out.println(
                        "Tried to out of the board position (range : a->h & 1->8)");
                return false;
            }
            if (p1.x == p2.x && p1.y == p2.y) {
                if (player.getColor() == Player.BLACK) System.out.println(
                        "Tried to use the same position twice");
                return false;
            }
            return true;
        }

        boolean checkPieces() {
            if (piece1 == null) {
                if (player.getColor() == Player.BLACK) System.out.println(
                        "Tried to move an empty slot");
                return false;
            }
            if (piece1.getPlayer() != player.getColor()) {
                if (player.getColor() == Player.BLACK) System.out.println(
                        "Tried to move an enemy piece");
                return false;
            }
            onEnemy = piece2 != null && piece2.getPlayer() != player.getColor();
            if (piece2 != null && !onEnemy) {
                if (player.getColor() == Player.BLACK) System.out.println(
                        "Tried to move on an ally piece");
                return false;
            }
            return true;
        }

        boolean checkMove() {
            if (player.getColor() == Player.WHITE) {
                normalizedMove = new Move(p1.x, p1.y, p2.x, p2.y);
            }
            else {
                // Invert Y axis pour white move (to remove player dependency)
                normalizedMove = new Move(p1.x, 7 - p1.y, p2.x, 7 - p2.y);
            }
            if (!piece1.isValidMove(normalizedMove, onEnemy)) {
                if (player.getColor() == Player.BLACK) System.out.println(
                        "Invalid move for this piece");
                return false;
            }
            return true;
        }

        boolean checkSight() {
            if (piece1.needSight()) {
                int xInc = 0;
                int yInc = 0;

                if (p1.x < p2.x) xInc = 1;
                if (p1.x > p2.x) xInc = -1;
                if (p1.y < p2.y) yInc = 1;
                if (p1.y > p2.y) yInc = -1;

                int x = p1.x + xInc;
                int y = p1.y + yInc;
                while (x != p2.x || y != p2.y) {
                    if (grid[x][y].isOccupied()) {
                        if (player.getColor() == Player.BLACK) System.out.println(
                                "The piece has no place do to this move");
                        return false;
                    }
                    x += xInc;
                    y += yInc;
                }
            }
            return true;
        }

        void handlePromotion() {
            if (piece1 instanceof Pawn && normalizedMove.yF == 7) {
                if (player.getColor() == Player.BLACK) {
                    String className = "";
                    do {
                        if (!className.isEmpty()) {
                            System.out.println("Mauvais nom (Bishop, Knight, Queen or Rock)");
                        }
                        System.out.println("Entrez le type de la pièce promue:");
                        try {
                            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
                            className = reader.readLine();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    } while (!getPromotionNames().contains(className));

                    try {
                        Class<?> pieceClass = Class.forName("chess.piece." + className);
                        Constructor<?> ctor = pieceClass.getConstructor(int.class);
                        grid[p2.x][p2.y].setPiece((Piece) ctor.newInstance(piece1.getPlayer()));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                else {
                    grid[p2.x][p2.y].setPiece(new Queen(piece1.getPlayer()));
                }
            }
        }
    }

}
