#! /bin/bash
function SayRandomWord () {
	word=$(head -$((${RANDOM} % `wc -l < /usr/share/dict/words` + 1)) /usr/share/dict/words | tail -1)
	echo $word
	say $word
}
SayRandomWord
