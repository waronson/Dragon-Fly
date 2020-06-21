using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerStart : MonoBehaviour
{
	[SerializeField] GameObject playerPrefab;
	[SerializeField] CameraController cameraController;

	private void Start()
	{
		SpawnPlayer();
	}

	public void SpawnPlayer()
	{
		GameObject go = Instantiate(playerPrefab);
		go.SetActive(true);
		cameraController.CameraTarget = go.transform;
	}
}
