package main

import (
	"bufio"
	"bytes"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"sort"
	"strconv"
	"strings"
)

var boardCosts = map[string]float64{
	"2x4x8": 7.75,
	"2x4x10": 12.98,
	"2x4x12": 14.53,
	"2x4x16": 21.22,


	"2x6x8": 13.55,
	"2x6x10": 19.45,
	"2x6x12": 21.57,
	"2x6x16": 29.34,
}

type Board struct {
	Dimensions string
	Length     float64

	Used bool
}

type BoardLen map[float64]int
type CutList map[string]BoardLen

func main() {
	var openscadBin string

	flag.StringVar(&openscadBin, "openscad-bin", "openscad", "Which openscad binary to use")

	flag.Parse()

	if len(os.Args) <= 1 || os.Args[len(os.Args)-1] == "" {
		fmt.Println("Error: Missing input file")
		fmt.Printf("Usage: %s [options] <input file>\n\n", os.Args[0])
		os.Exit(1)
	}
	
	infile := os.Args[len(os.Args)-1]

	cmd := exec.Command(openscadBin, "--export-format=3mf", "-o", "/dev/null", infile)

	// fmt.Printf("Executing %s\n", cmd)

	output, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Printf("Error executing file: %v\n", err)
		os.Exit(1)
	}

	boards := []Board{}

	scanner := bufio.NewScanner(bytes.NewBuffer(output))
	for scanner.Scan() {
		fields := strings.Split(scanner.Text(), "\t")
		if len(fields) < 3 {
			continue
		}

		// Fields looks like: ["Echo: \"Board", "2x4", "36\""]
		size := fields[1]
		lenS := strings.ReplaceAll(fields[2], "\"", "")

		len, _ := strconv.ParseFloat(lenS, 64)

		boards = append(boards, Board{Dimensions: size, Length: len})
	}

	if scanner.Err() != nil {
		// Handle error.
	}

	// Add up cuts
	cuts := make(CutList)

	for _, b := range boards {
		if _, ok := cuts[b.Dimensions]; !ok {
			cuts[b.Dimensions] = make(BoardLen)
		}

		cuts[b.Dimensions][b.Length]++
	}

	fmt.Println("---------- Board Cuts ----------")
	for board, list := range cuts {
		for len, count := range list {
			fmt.Printf("%sx%v - %d\n", board, len, count)
		}
	}
	fmt.Println("")

	fmt.Println("---------- Board Buy ----------")
	for _, len := range []int{8,10,12,16} {
		fmt.Printf("--- %d foot boards ---\n", len)
		PrintBoardCounts(len, boards)
		fmt.Println("")
	}
}

func PrintBoardCounts(maxLenFt int, boards []Board) {
	boardsToBuy := CalcBoards(maxLenFt, boards)
	boardCounts := make(map[string]int)

	for _, b := range boardsToBuy {
		boardCounts[b.Dimensions]++
	}

	keys := make([]string, 0, len(boardCounts))
	for k := range boardCounts {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	total := float64(0)

	for _, k := range keys {
		bId := fmt.Sprintf("%sx%d", k, maxLenFt)
		fmt.Printf("%s - %d ($%0.2f)\n", bId, boardCounts[k], boardCosts[bId]*float64(boardCounts[k]))
		total += boardCosts[bId]*float64(boardCounts[k])
	}

	fmt.Printf("Total: $%0.2f\n", total)
}

func CalcBoards(maxLenFt int, boardsIn []Board) []Board {
	boardsToBuy := []Board{}
	boards := append(make([]Board, 0, len(boardsIn)), boardsIn...)
	done := false
	for !done {
		updates := false
		for i, b := range boards {
			if b.Used {
				continue
			}

			// fmt.Printf("Board (%vx%v)\n", b.Dimensions, b.Length)

			boardFound := false
			for bi, bb := range boardsToBuy {
				if b.Dimensions == bb.Dimensions && b.Length < bb.Length {
					boards[i].Used = true
					boardsToBuy[bi].Length -= b.Length
					boardFound = true
					updates = true
					// fmt.Printf("Cut %d from board %d\n", i, bi)
					break
				}
			}

			if !boardFound {
				nb := Board{Dimensions: b.Dimensions, Length: float64(12 * maxLenFt)}
				nb.Length -= b.Length
				boards[i].Used = true
				boardsToBuy = append(boardsToBuy, nb)
				// fmt.Printf("New Boards: Cut %d from board %d\n", i, len(boardsToBuy))
				updates = true
			}
		}

		if updates == false {
			done = true
		}
	}

	return boardsToBuy
}
