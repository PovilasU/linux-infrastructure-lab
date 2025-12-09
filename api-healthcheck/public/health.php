<?php
header('Content-Type: application/json; charset=utf-8');

$response = [
    'status' => 'OK',
    'php_version' => phpversion(),
    'server_time' => date('c'),
    'hostname' => gethostname(),
];

// OPTIONAL: DB test ---------------------------------------------------
// OPTIONAL: DB test ---------------------------------------------------
try {
    $pdo = new PDO(
        "mysql:host=localhost;dbname=healthcheck_db;charset=utf8mb4",
        "healthuser",
        "labai_slapta_sveikata123",
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        ]
    );
    $pdo->query("SELECT 1");
    $response['database'] = 'OK';
} catch (Exception $e) {
    $response['database'] = 'ERROR';
    $response['status'] = 'DEGRADED';
    $response['db_error'] = $e->getMessage();
}
// ---------------------------------------------------------------------


// ---------------------------------------------------------------------

echo json_encode($response, JSON_PRETTY_PRINT);

