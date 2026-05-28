package com.gajimeter.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableLongStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.gajimeter.app.ui.theme.GajiMeterTheme
import kotlinx.coroutines.delay
import java.util.Locale
import kotlin.math.min

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            GajiMeterTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    SalaryTrackerApp()
                }
            }
        }
    }
}

@Composable
fun SalaryTrackerApp() {
    var salary by rememberSaveable { mutableStateOf("4300") }
    var days by rememberSaveable { mutableStateOf("20") }
    var hours by rememberSaveable { mutableStateOf("8") }

    var isTracking by rememberSaveable { mutableStateOf(false) }
    var sessionStartMillis by rememberSaveable { mutableLongStateOf(0L) }
    var savedElapsedMillis by rememberSaveable { mutableLongStateOf(0L) }
    var currentMillis by remember { mutableLongStateOf(System.currentTimeMillis()) }

    val salaryDouble = salary.toDoubleOrNull() ?: 0.0
    val daysInt = days.toIntOrNull() ?: 0
    val hoursInt = hours.toIntOrNull() ?: 0

    val totalSecondsWorkedPerMonth = daysInt * hoursInt * 3600
    val earningsPerSecond = if (totalSecondsWorkedPerMonth > 0) {
        salaryDouble / totalSecondsWorkedPerMonth
    } else {
        0.0
    }

    val dailyTarget = if (daysInt > 0) salaryDouble / daysInt else 0.0
    val hourlyRate = if (daysInt > 0 && hoursInt > 0) salaryDouble / daysInt / hoursInt else 0.0
    val minuteRate = hourlyRate / 60.0

    LaunchedEffect(isTracking) {
        while (isTracking) {
            currentMillis = System.currentTimeMillis()
            delay(1000L)
        }
    }

    val elapsedMillis by remember(isTracking, sessionStartMillis, savedElapsedMillis, currentMillis) {
        derivedStateOf {
            if (isTracking) {
                savedElapsedMillis + (currentMillis - sessionStartMillis).coerceAtLeast(0L)
            } else {
                savedElapsedMillis
            }
        }
    }

    val earnedAmount = (elapsedMillis / 1000.0) * earningsPerSecond
    val progress = if (dailyTarget > 0) min((earnedAmount / dailyTarget).toFloat(), 1f) else 0f

    val statusText = if (isTracking) "Working now" else if (earnedAmount > 0) "Paused" else "Ready"
    val statusColor by animateColorAsState(
        targetValue = if (isTracking) Color(0xFF10B981) else Color(0xFF64748B),
        label = "statusColor"
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp),
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "GajiMeter",
            fontSize = 34.sp,
            fontWeight = FontWeight.ExtraBold,
            color = MaterialTheme.colorScheme.onBackground
        )

        Text(
            text = "See your work value grow in real time.",
            fontSize = 15.sp,
            color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.65f),
            modifier = Modifier.padding(top = 4.dp, bottom = 24.dp)
        )

        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(28.dp),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
        ) {
            Column(
                modifier = Modifier.padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                StatusPill(text = statusText, color = statusColor)

                Spacer(modifier = Modifier.height(18.dp))

                Text(
                    text = "Earned This Session",
                    fontSize = 14.sp,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.65f)
                )

                Text(
                    text = String.format(Locale.US, "RM %.2f", earnedAmount),
                    fontSize = 48.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(top = 8.dp)
                )

                Text(
                    text = String.format(Locale.US, "+ RM %.4f / second", earningsPerSecond),
                    fontSize = 13.sp,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.60f),
                    modifier = Modifier.padding(top = 4.dp)
                )

                Spacer(modifier = Modifier.height(24.dp))

                LinearProgressIndicator(
                    progress = { progress },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(10.dp)
                        .clip(RoundedCornerShape(99.dp)),
                    color = MaterialTheme.colorScheme.primary,
                    trackColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                )

                Text(
                    text = String.format(Locale.US, "%.0f%% of daily value", progress * 100),
                    fontSize = 13.sp,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.60f),
                    modifier = Modifier.padding(top = 8.dp)
                )
            }
        }

        Spacer(modifier = Modifier.height(18.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            StatCard(
                label = "Per Hour",
                value = String.format(Locale.US, "RM %.2f", hourlyRate),
                modifier = Modifier.weight(1f)
            )

            StatCard(
                label = "Per Minute",
                value = String.format(Locale.US, "RM %.2f", minuteRate),
                modifier = Modifier.weight(1f)
            )
        }

        Spacer(modifier = Modifier.height(18.dp))

        InputSection(
            salary = salary,
            onSalaryChange = { salary = it },
            days = days,
            onDaysChange = { days = it },
            hours = hours,
            onHoursChange = { hours = it },
            enabled = !isTracking
        )

        Spacer(modifier = Modifier.height(22.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Button(
                onClick = {
                    if (isTracking) {
                        savedElapsedMillis = elapsedMillis
                        isTracking = false
                    } else {
                        currentMillis = System.currentTimeMillis()
                        sessionStartMillis = currentMillis
                        isTracking = true
                    }
                },
                modifier = Modifier.weight(1f)
            ) {
                Text(if (isTracking) "Stop Working" else "Start Working")
            }

            OutlinedButton(
                onClick = {
                    savedElapsedMillis = 0L
                    sessionStartMillis = System.currentTimeMillis()
                    currentMillis = sessionStartMillis
                    isTracking = false
                },
                modifier = Modifier.weight(1f),
                enabled = !isTracking && earnedAmount > 0.0
            ) {
                Text("Reset")
            }
        }
    }
}

@Composable
private fun StatusPill(
    text: String,
    color: Color
) {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(99.dp))
            .background(color.copy(alpha = 0.12f))
            .padding(horizontal = 14.dp, vertical = 8.dp)
    ) {
        Text(
            text = text,
            color = color,
            fontWeight = FontWeight.SemiBold,
            fontSize = 13.sp
        )
    }
}

@Composable
private fun StatCard(
    label: String,
    value: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier,
        shape = RoundedCornerShape(22.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = label,
                fontSize = 12.sp,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.60f)
            )
            Text(
                text = value,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.padding(top = 4.dp)
            )
        }
    }
}

@Composable
private fun InputSection(
    salary: String,
    onSalaryChange: (String) -> Unit,
    days: String,
    onDaysChange: (String) -> Unit,
    hours: String,
    onHoursChange: (String) -> Unit,
    enabled: Boolean
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            OutlinedTextField(
                value = salary,
                onValueChange = onSalaryChange,
                label = { Text("Monthly Salary (RM)") },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                modifier = Modifier.fillMaxWidth(),
                enabled = enabled,
                singleLine = true
            )

            Spacer(modifier = Modifier.height(10.dp))

            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                OutlinedTextField(
                    value = days,
                    onValueChange = onDaysChange,
                    label = { Text("Days") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f),
                    enabled = enabled,
                    singleLine = true
                )

                OutlinedTextField(
                    value = hours,
                    onValueChange = onHoursChange,
                    label = { Text("Hours") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f),
                    enabled = enabled,
                    singleLine = true
                )
            }
        }
    }
}
