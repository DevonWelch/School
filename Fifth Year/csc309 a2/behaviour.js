var game=document.getElementById("game-view");
var gameCtx=game.getContext("2d");

game.addEventListener("click", determineAction, false);

var paused = false;
var playing = false;
var level = 1;
var numFood = 5;
var time = 60;
var score = 0;
var food = [];
var bugList = [];
var fadeList = [];

function determineAction() {
	if (131 < event.offsetX && event.offsetX < 268 && event.offsetY < 25 && playing == true) {
		pauseOrPlay(gameCtx, game);
	} else if ((firstCircleX - 8 <= event.offsetX && event.offsetX <= firstCircleX + 8) && (234 <= event.offsetY && event.offsetY <= 250) && level == 2) {
		changeLevel(gameCtx, game);
	} else if ((secondCircleX - 8 <= event.offsetX && event.offsetX <= secondCircleX + 8) && (234 <= event.offsetY && event.offsetY <= 250) && level == 1) {
		changeLevel(gameCtx, game);
	} else if ((160 <= event.offsetX && event.offsetX <= 240) && (400 <= event.offsetY && event.offsetY <= 430) && playing == false) {
		startGame(gameCtx, game);
	} else if ((25 < event.offsetY) && (playing == true)) {
		splat(gameCtx, game, event.offsetX, event.offsetY);
	}
}

function pauseOrPlay(ctx, source) {
	if (window.paused == true) {
		window.paused = false;
		drawPauseButton(ctx, source);
	} else {
		window.paused = true;
		drawPlayButton(ctx, source);
	}
}

function drawPlayButton(ctx, source) {
	ctx.fillStyle="white";
	var width = source.width;
	ctx.fillRect(width/2 - 15, 0, 25, 20);
	ctx.fillStyle="green";
	ctx.strokeStyle="green";
	ctx.lineWidth = 1;
	ctx.beginPath();
	ctx.moveTo(width/2 - 7, 2);
	ctx.lineTo(width/2 - 7, 20);
	ctx.lineTo(width/2 + 7, 11);
	ctx.stroke();
	ctx.fill();
}

function drawPauseButton(ctx, source) {
	ctx.fillStyle="white";
	var width = source.width;
	ctx.fillRect(width/2 - 10, 0, 25, 21);
	ctx.strokeStyle="red";
	ctx.lineWidth = 5;
	ctx.beginPath();
	ctx.moveTo(width/2 - 5, 3);
	ctx.lineTo(width/2 - 5, 19);
	ctx.stroke();
	ctx.moveTo(width/2 + 5, 3);
	ctx.lineTo(width/2 + 5, 19);
	ctx.stroke();
}

function startScreen(ctx, source) {
	ctx.font="20px Arial";
	var hsText;
	if (typeof(Storage) !== "undefined") {
		if (localStorage.highScore) {
			hsText = "High Score: " + localStorage.highScore.toString();
		} else {
			hsText = "High Score: 0";
			localStorage.highScore = 0;
		}
		var width = source.width;
		var hsWidth = ctx.measureText(hsText).width;
		ctx.textAlign="left";
		ctx.fillText("Level:", width/2 - parseInt(hsWidth)/2, 250);
		ctx.textAlign="center";
		ctx.fillText(hsText, width/2, 300);
		lvlWidth = ctx.measureText("Level:").width;
		firstCircleX = width/2 + lvlWidth/2 - 8;
		secondCircleX = width/2 + parseInt(hsWidth)/2 - 8;
		ctx.beginPath();
		ctx.arc(firstCircleX, 242, 8,0,2*Math.PI);
		ctx.fillStyle="black";
		ctx.fill();
		ctx.moveTo(secondCircleX+8, 242);
		ctx.arc(secondCircleX, 242, 8,0,2*Math.PI);
		ctx.stroke();
		ctx.fillText("1", firstCircleX, 270);
		ctx.fillText("2", secondCircleX, 270);
		ctx.strokeRect(160, 400, 80, 30);
		ctx.fillText("Start", width/2, 422);
	} else {
		alert("no storage");
	}
}

function endGame(ctx, source, winOrLose) {
	level = 1;
	numFood = 5;
	time = 60;
	food = [];
	bugList = [];
	fadeList = [];
	ctx.fillStyle="white";
	ctx.fillRect(0, 0, source.width, source.height);
	playing = false;
	if (score > localStorage.highScore) {
		localStorage.highScore = score;
	}
	ctx.font="20px Arial";
	var hsText;
	if (typeof(Storage) !== "undefined") {
		if (localStorage.highScore) {
			hsText = "High Score: " + localStorage.highScore.toString();
		} else {
			hsText = "High Score: 0";
			localStorage.highScore = 0;
		}
		var width = source.width;
		var hsWidth = ctx.measureText(hsText).width;
		ctx.fillStyle = "black";
		ctx.textAlign="center";
		if (winOrLose == "win") {
			ctx.fillText("You won!", width/2, 150);
		} else {
			ctx.fillText("You lost...", width/2, 150);
		}
		ctx.fillText("Your score was: " + score.toString(), width/2, 200);
		ctx.textAlign="left";
		score = 0;
		ctx.fillText("Level:", width/2 - parseInt(hsWidth)/2, 250);
		ctx.textAlign="center";
		ctx.fillText(hsText, width/2, 300);
		lvlWidth = ctx.measureText("Level:").width;
		firstCircleX = width/2 + lvlWidth/2 - 8;
		secondCircleX = width/2 + parseInt(hsWidth)/2 - 8;
		ctx.beginPath();
		ctx.arc(firstCircleX, 242, 8,0,2*Math.PI);
		ctx.fillStyle="black";
		ctx.fill();
		ctx.closePath();
		ctx.beginPath();
		ctx.moveTo(secondCircleX+8, 242);
		ctx.arc(secondCircleX, 242, 8,0,2*Math.PI);
		ctx.stroke();
		ctx.fillText("1", firstCircleX, 270);
		ctx.fillText("2", secondCircleX, 270);
		ctx.strokeRect(160, 400, 80, 30);
		ctx.fillText("Start", width/2, 422);
		ctx.closePath();
	} else {
		alert("no storage");
	}
}

function changeLevel(ctx, source) {
	if (level == 1) {
		ctx.fillStyle="white";
		ctx.beginPath();
		ctx.arc(firstCircleX, 242, 8,0,2*Math.PI);
		ctx.fill();
		ctx.stroke();
		ctx.closePath();
		ctx.beginPath();
		ctx.fillStyle = "black";
		ctx.arc(secondCircleX, 242, 8,0,2*Math.PI);
		ctx.fill();
		level = 2;
	} else {
		ctx.beginPath();
		ctx.arc(firstCircleX, 242, 8,0,2*Math.PI);
		ctx.fillStyle="black";
		ctx.fill();
		ctx.closePath();
		ctx.beginPath();
		ctx.fillStyle="white";
		ctx.moveTo(secondCircleX+8, 242);
		ctx.arc(secondCircleX, 242, 8,0,2*Math.PI);
		ctx.fill();
		ctx.stroke();
		level = 1;
	}
}

function startGame(ctx, source) {
	ctx.fillStyle = "white";
	ctx.fillRect(0, 0, source.width, source.height);
	doStuff(ctx, source);
	spawnFood(ctx, source);
	playing = true;
	spawnHelper();
	startTime(ctx, source);
}

function spawnFood(ctx, source) {
	for (o = 0; o < numFood; o ++) {
		xLocation = Math.random() * source.width;
		yLocation = (Math.random() * (source.height - 25) * 0.8) + 0.2 * (source.height - 25) + 25;
		drawFood(ctx, source, xLocation, yLocation);
		food.push([xLocation, yLocation]);
	}
}

function fillInfoBar(ctx, source) {
	if (paused == false) {
		drawPauseButton(ctx, source);
	} else {
		drawPlayButton(ctx, source);
	}
	ctx.lineWidth = 1;
	ctx.fillStyle="black";
	ctx.font="20px Arial";
	ctx.textAlign="left";
	ctx.fillText(time + " sec", 20, 20);
	ctx.textAlign="right";
	ctx.fillText("Score: " + score, source.width - 20, 20);
	ctx.beginPath();
	ctx.moveTo(0, 25);
	ctx.lineTo(source.width, 25);
	ctx.strokeStyle="lightgray";
	ctx.stroke();
}

function drawFood(ctx, source, x, y) {
	ctx.beginPath();
	ctx.fillStyle = "darkBlue";
	ctx.moveTo(x+2, y+1);
	ctx.arc(x+1, y+1, 2, 0, 2*Math.PI);
	ctx.moveTo(x+2, y-1);
	ctx.arc(x+1, y-1, 2, 0, 2*Math.PI);
	ctx.moveTo(x, y+1);
	ctx.arc(x-1, y+1, 2, 0, 2*Math.PI);
	ctx.moveTo(x, y-1);
	ctx.arc(x-1, y-1, 2, 0, 2*Math.PI);
	ctx.fill();
	ctx.closePath();
	ctx.beginPath();
	ctx.fillStyle="blue";
	ctx.moveTo(x+2, y+5);
	ctx.arc(x+1, y+5, 2, 0, 2*Math.PI);
	ctx.moveTo(x+2, y-5);
	ctx.arc(x+1, y-5, 2, 0, 2*Math.PI);
	ctx.moveTo(x, y+5);
	ctx.arc(x-1, y+5, 2, 0, 2*Math.PI);
	ctx.moveTo(x, y-5);
	ctx.arc(x-1, y-5, 2, 0, 2*Math.PI);
	ctx.moveTo(x+6, y+1);
	ctx.arc(x+5, y+1, 2, 0, 2*Math.PI);
	ctx.moveTo(x+6, y-1);
	ctx.arc(x+5, y-1, 2, 0, 2*Math.PI);
	ctx.moveTo(x-4, y+1);
	ctx.arc(x-5, y+1, 2, 0, 2*Math.PI);
	ctx.moveTo(x-4, y-1);
	ctx.arc(x-5, y-1, 2, 0, 2*Math.PI);
	ctx.fill();
	ctx.closePath();
	ctx.beginPath();
	ctx.fillStyle="deepSkyBlue";
	ctx.moveTo(x+6, y+5);
	ctx.arc(x+5, y+5, 2, 0, 2*Math.PI);
	ctx.moveTo(x+6, y-5);
	ctx.arc(x+5, y-5, 2, 0, 2*Math.PI);
	ctx.moveTo(x-4, y+5);
	ctx.arc(x-5, y+5, 2, 0, 2*Math.PI);
	ctx.moveTo(x-4, y-5);
	ctx.arc(x-5, y-5, 2, 0, 2*Math.PI);
	ctx.moveTo(x+1, y+8);
	ctx.arc(x, y+8, 1, 0, 2*Math.PI);
	ctx.moveTo(x+1, y-8);
	ctx.arc(x, y-8, 1, 0, 2*Math.PI);
	ctx.moveTo(x+9, y);
	ctx.arc(x+8, y, 1, 0, 2*Math.PI);
	ctx.moveTo(x-7, y);
	ctx.arc(x-8, y, 1, 0, 2*Math.PI);
	ctx.fill();
	ctx.closePath();
}

function spawnBug(ctx, source) {
	if (playing == true) {
		if (paused == false) {
			xLocation = Math.random() * 380 + 10;
			bugTypeP = Math.random();
			if (bugTypeP <= 0.3) {
				bugType = "black";
			} else if (bugTypeP <= 0.6) {
				bugType = "red";
			} else {
				bugType = "orange";
			}
			drawBug(ctx, source, xLocation, 25, bugType);
			nearestFood = findFood(ctx, source, xLocation, 25);
			angle = getAngle(ctx, source, xLocation, 25, nearestFood[0], nearestFood[1]);
			mods = getMods(ctx, source, xLocation, 25, nearestFood[0], nearestFood[1]);
			bugList.push({"x":xLocation, "y":25, "type":bugType, "target":nearestFood, "angle":angle, "mods":mods, "alpha":1, "currentAngle":angle});
		}
		spawnTime = (Math.random() * 2 + 1) * 1000;
		setTimeout(spawnHelper, spawnTime);
	}
}

function spawnHelper() {
	spawnBug(gameCtx, game);
}

function getAngle(ctx, source, x1, y1, x2, y2) {
	tempAngle = Math.abs(y1 - y2) / getDistance(ctx, source, x1, y1, x2, y2);
	tempAngle = Math.asin(tempAngle) * 180 / Math.PI;
	if ((x1 > x2) && (y2 > y1)) { //quadrant 2
		angle = 180 - tempAngle;
	} else if ((x1 > x2) && (y1 > y2)) { //quadrant 3
		angle = 180 + tempAngle;
	} else if ((x2 > x1) && (y1 > y2)) {//quadrant 4
		angle = 360 - tempAngle;
	} else { //quadrant 1
		angle = tempAngle;
	}
	return angle;
}

function getMods(ctx, source, x1, y1, x2, y2) {
	hypotenuse = getDistance(ctx, source, x1, y1, x2, y2);
	return [(x2 - x1)/hypotenuse, (y2 - y1)/hypotenuse];
}

function drawBug(ctx, source, x, y, bugType) {
	ctx.fillStyle = bugType;
	ctx.beginPath();
	ctx.strokeStyle = bugType;
	ctx.moveTo(0,-3);
	ctx.arc(0, 0, 3,0,2*Math.PI);
	ctx.moveTo(-7,-4);
	ctx.arc(-7, 0, 4,0,2*Math.PI);
	ctx.moveTo(6,-3);
	ctx.arc(6, 0, 3,0,2*Math.PI);
	ctx.closePath();
	ctx.fill();
	ctx.beginPath();
	ctx.moveTo(0, 2);
	ctx.bezierCurveTo(3,3, 5, 5, 7, 5);
	ctx.moveTo(0, -2);
	ctx.bezierCurveTo(3,-3, 5, -5, 7, -5);
	ctx.moveTo(-1, 2);
	ctx.bezierCurveTo(1,3, 2, 3, -1, 6);
	ctx.moveTo(-1, -2);
	ctx.bezierCurveTo(1,-3, 2, -3, -1, -6);
	ctx.moveTo(-1, 2);
	ctx.bezierCurveTo(-2,3, -3, 3, -5, 6);
	ctx.moveTo(-1, -2);
	ctx.bezierCurveTo(-2,-3, -3, -3, -5, -6);
	ctx.moveTo(9.4, 1.5);
	ctx.arcTo(12, 6, 16, 4, 3);
	ctx.moveTo(9.4, -1.5);
	ctx.arcTo(12, -6, 16, -4, 3);
	ctx.stroke();
	ctx.closePath();
}

function doStuff(ctx, source) {
	if (paused == false) {
		ctx.fillStyle="white";
		ctx.fillRect(0, 0, source.width, source.height);
		for (n = 0; n < food.length; n++) {
			drawFood(ctx, source, food[n][0], food[n][1]);
		}
		moveBugs(ctx, source);
		fillInfoBar(ctx, source);
		fadeBugs(ctx, source);
	}
	setTimeout(doStuffHelper, 20);
}

function doStuffHelper() {
	if (playing == true) {
		doStuff(gameCtx, game);
	}
}

function moveBugs(ctx, source) {
	if (playing == true) {
		for (m = 0; m < bugList.length; m ++) {
			if (playing == true) {
				ctx.save();
				moveBug(ctx, source, bugList[m]);
				ctx.restore();
			}
		}
	}
}

function moveBug(ctx, source, bug) {
	turning = false;
	waiting = false;
	if (bug.currentAngle > 360) {
		bug.currentAngle = bug.currentAngle - 360;
	} else if (bug.currentAngle < 0) {
		bug.currentAngle = bug.currentAngle + 360;
	}
	if (bug.currentAngle != bug.angle) {
		if (Math.abs(bug.currentAngle - bug.angle) < 10) {
			bug.currentAngle = bug.angle;
		} else if ((bug.angle - bug.currentAngle < 180 && bug.angle - bug.currentAngle > 0) || bug.angle - bug.currentAngle < -180) {
			bug.currentAngle = bug.currentAngle + 10;
		} else {
			bug.currentAngle = bug.currentAngle - 10;
		}
		turning = true;
	}
	for (a = 0; a < bugList.length; a++) {
		if (bugList[a] != bug) {
			if (getDistance(ctx, source, bug.x, bug.y, bugList[a].x, bugList[a].y) < 30) {
				if ((bug.type == "orange" && (bugList[a].type == "black" || bugList[a].type == "red")) || (bug.type == "red" && bugList[a].type == "black") || (bug.type == bugList[a].type && bugList[a].x < bug.x)) {
					waiting = true;
				}
			}
		}
	}
	if (level == 1 && !turning && !waiting) {
		if (bug.type == "black") {
			bug.x = bug.x + bug.mods[0]*3;
			bug.y = bug.y + bug.mods[1]*3;
		} else if (bug.type == "red") {
			bug.x = bug.x + bug.mods[0]*1.5;
			bug.y = bug.y + bug.mods[1]*1.5;
		} else {
			bug.x = bug.x + bug.mods[0]*1.2;
			bug.y = bug.y + bug.mods[1]*1.2;
		}
	} else if (!turning && !waiting) {
		if (bug.type == "black") {
			bug.x = bug.x + bug.mods[0]*4;
			bug.y = bug.y + bug.mods[1]*4;
		} else if (bug.type == "red") {
			bug.x = bug.x + bug.mods[0]*2;
			bug.y = bug.y + bug.mods[1]*2;
		} else {
			bug.x = bug.x + bug.mods[0]*1.6;
			bug.y = bug.y + bug.mods[1]*1.6;
		}
	}
	if (getDistance(ctx, source, bug.x, bug.y, bug.target[0], bug.target[1]) <= 3) {
		if (food.length == 1) {
			playing = false;
			endGame(ctx, source, "lose");
			return;
		} 
		for (l = 0; l < food.length; l ++) {
			if ((food[l][0] == bug.target[0]) && (food[l][1] == bug.target[1])) {
				food.splice(l, 1);
				recalculateBugs(ctx, source);
				l = food.length;
			}
		}
	}
	ctx.translate(bug.x, bug.y);
	ctx.rotate(bug.currentAngle * Math.PI / 180);
	drawBug(ctx, source, bug.x, bug.y, bug.type);
}

function splat(ctx, source, x, y) {
	if (paused == false) {
		for (k = 0; k < bugList.length; k ++) {
			if (getDistance(ctx, source, bugList[k].x, bugList[k].y, x, y) <= 30) {
				//fadeBug(ctx, source, bugList[i], 1);
				fadeList.push(bugList[k]);
				if (bugList[k].type == "black") {
					score += 5;
				} else if (bugList[k].type == "red") {
					score += 3;
				} else {
					score += 1;
				}
				bugList.splice(k, 1);
				k = k - 1;
			}
		}
	}
}

function findFood(ctx, source, x, y) {
	minDist = 1000000;
	for (j = 0; j < food.length; j ++) {
		tempDist = getDistance(ctx, source, x, y, food[j][0], food[j][1]);
		if (tempDist <= minDist) {
			minDist = tempDist;
			coords = food[j];
		}
	}
	return coords;
}

function recalculateBugs(ctx, source) {
	for (i = 0; i < bugList.length; i++) {
		bugList[i].target = findFood(ctx, source, bugList[i].x, bugList[i].y);
		bugList[i].angle = getAngle(ctx, source, bugList[i].x, bugList[i].y, bugList[i].target[0], bugList[i].target[1]);
		bugList[i].mods = getMods(ctx, source, bugList[i].x, bugList[i].y, bugList[i].target[0], bugList[i].target[1]);
	}
}

function timeDown (ctx, source) {
	if (paused == false) {
		time = time - 1;
		if ((time == 0) && (level == 1)) {
			level = 2;
			time = 60;
		} else if ((time == 0) && (level == 2)) {
			playing = false;
			endGame(ctx, source, "win");
		}
	}
	setTimeout(timeHelper, 1000);
}

function timeHelper() {
	if (playing == true){
		timeDown(gameCtx, game);
	}
}

function getDistance(ctx, source, x1, y1, x2, y2) {
	return Math.sqrt(Math.pow(Math.abs(x1-x2), 2) + Math.pow(Math.abs(y1-y2), 2));
}

function startTime(ctx, source) {
	setTimeout(timeHelper, 1000);
}

function fadeBugs(ctx, source) {
	for (p = 0; p < fadeList.length; p ++) {
		ctx.save();
		ctx.translate(fadeList[p].x, fadeList[p].y);
		ctx.rotate(fadeList[p].currentAngle * Math.PI / 180);
		ctx.globalAlpha = fadeList[p].alpha;
		ctx.fillStyle = fadeList[p].type;
		ctx.strokeStyle = fadeList[p].type;
		ctx.beginPath();
		ctx.moveTo(0,-3);
		ctx.arc(0, 0, 3,0,2*Math.PI);
		ctx.moveTo(-7,-4);
		ctx.arc(-7, 0, 4,0,2*Math.PI);
		ctx.moveTo(6,-3);
		ctx.arc(5, 0, 3,0,2*Math.PI);
		ctx.closePath();
		ctx.fill();
		ctx.beginPath();
		ctx.moveTo(0, 2);
		ctx.bezierCurveTo(3,3, 5, 5, 7, 5);
		ctx.moveTo(0, -2);
		ctx.bezierCurveTo(3,-3, 5, -5, 7, -5);
		ctx.moveTo(-1, 2);
		ctx.bezierCurveTo(1,3, 2, 3, -1, 6);
		ctx.moveTo(-1, -2);
		ctx.bezierCurveTo(1,-3, 2, -3, -1, -6);
		ctx.moveTo(-1, 2);
		ctx.bezierCurveTo(-2,3, -3, 3, -5, 6);
		ctx.moveTo(-1, -2);
		ctx.bezierCurveTo(-2,-3, -3, -3, -5, -6);
		ctx.moveTo(9.4, 1.5);
		ctx.arcTo(12, 6, 16, 4, 3);
		ctx.moveTo(9.4, -1.5);
		ctx.arcTo(12, -6, 16, -4, 3);
		ctx.stroke();
		ctx.closePath();
		ctx.restore();
		if (fadeList[p].alpha > 0.01) {
			fadeList[p].alpha = fadeList[p].alpha - 0.01;
		} else {
			fadeList.splice(p, 1);
			p = p - 1;
		}
	}
}

//todo: overtaking/no overlapping

startScreen(gameCtx, game);